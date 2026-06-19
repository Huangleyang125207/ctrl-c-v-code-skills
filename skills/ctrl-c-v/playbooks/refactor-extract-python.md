# Refactor extraction — Python-specific gotchas

> **Python 专属**。Rust / Go / Java / TS 用户应**忽略本 playbook** — 各栈
> 等价问题在其语言里不存在 or 用不同 idiom 解(见 refactor-extract.md 主文件
> 的 per-stack 段)。
>
> 这里收的是 CPython import 系统 + dict 语义 + unittest.mock 三件套
> 跨模块时的具体陷阱,不是通用 doctrine。

## When to read this

在 Python 项目做 LARGE refactor extraction(monolith → 多模块),且踩到 import /
patch / mock 诡异时翻这里。SMALL/MEDIUM 改动用不上。

---

## G1 — Cross-module dependency: top-level vs lazy import

抽出模块后,新模块怎么引旧符号是个三选题。错选 = 循环 import / 测试 patch 失效 /
import 时副作用。

| Situation | Idiom | Why |
|---|---|---|
| New module is a pure leaf (no caller in server) | top-level `from server import name` 在 new module 顶 | no cycle, fastest lookup |
| Need to patch `X.foo` from test, X is a 3rd-party module | top-level `import X`,call site 写 `X.foo()` 不写 `foo()` | preserve module-attribute patch entrypoint (见 G3) |
| Circular: server imports new_module AND new_module needs server symbol | function-body `from server import name` (lazy) | break cycle + each call re-reads server's binding (test `setattr` stays effective) |

真实例(PULSE refactor — server.py 9499 → 8593,拆出 4 模块):

```python
# pulse_io.py — leaf,server import 它,它不反向 import server
from pathlib import Path
PULSE_DIR = Path("...")  # 顶 import 无依赖 → 安全

# pulse_eval.py — 调 server._llm_chat,server 也 import pulse_eval
# 顶 import 会 cycle → 函数内 lazy
def run_eval(payload):
    from server import _llm_chat  # 每次进函数现取
    return _llm_chat(...)
```

为什么 lazy import 而不是 top-level + 测试 `monkeypatch.setattr(pulse_eval, "_llm_chat", spy)`?
后者也行,但 lazy import 多一层保险:server 把 `_llm_chat` 重新绑定时(很罕见但发生过)
lazy 版本看到新值,top-level 缓存的旧 ref 还指向老对象。

PEP 328 (absolute/relative imports) + Python docs "The import system" §
"Submodules" 是经典出处。

---

## G2 — dict reference vs module attribute (mutable shared state)

Python 的 dict 跨模块**引用共享**(同一个 PyDictObject);module-level 标量常量
(`PULSE_DIR = Path(...)`)**每次 import 重新绑定到 importer 的命名空间**。这导致
fixture 写法完全不同。

```python
# server.py
PULSE_DIR = Path("/real/path")              # 标量
_SELF_EVOLVE_TARGETS = {                    # dict (shared ref)
    "user_pulse": {"path": lambda: _USER_PULSE_PATH},
    "project":   {"path": lambda: _PROJECT_PULSE_PATH},
}

# pulse_eval.py
from server import PULSE_DIR, _SELF_EVOLVE_TARGETS
```

测试场景:

```python
# patch dict 的 item — 跨模块生效(都指向同一个 dict 对象)
monkeypatch.setitem(
    server._SELF_EVOLVE_TARGETS["user_pulse"],
    "path",
    lambda: tmp_path,
)
# pulse_eval.py 里 _SELF_EVOLVE_TARGETS["user_pulse"]["path"] 现在也是 tmp_path ✓

# patch 标量常量 — 只影响 ONE module's copy
monkeypatch.setattr(server, "PULSE_DIR", tmp_path)
# pulse_eval.PULSE_DIR 还指向 /real/path ✗
# fixture 必须 patch 两边:
monkeypatch.setattr(server, "PULSE_DIR", tmp_path)
monkeypatch.setattr(pulse_eval, "PULSE_DIR", tmp_path)
```

跨模块 fixture 模板见 G4。

CPython implementation detail:`from X import Y` 等价于
`Y = X.Y`(rebind 到当前模块 namespace)。dict 是引用类型故共享,Path/int/str
是值类型(其实也是 ref,但 monkeypatch.setattr 重绑名字不改对象)故分裂。

---

## G3 — Patch where used, not where defined

Python docs "unittest.mock — Where to patch" 原话:

> Patch where the name is looked up, not where it is defined.

抽完后最常踩。**用 leaf 模块(无回引)演示,避免跟 G1 的 lazy import
建议冲突** — 这里 `_pulse_validate` 住在 pulse_io.py(leaf module),
pulse_eval 单向 import 它,不存在循环,故顶层 `from pulse_io import ...`
是 G1 表第一行(top-level from-import,纯 leaf)的合规写法:

```python
# pulse_eval.py
from pulse_io import _pulse_validate   # rebind: pulse_eval._pulse_validate = pulse_io._pulse_validate

def run_eval(text):
    ok, err = _pulse_validate(text)     # 查的是 pulse_eval.__dict__["_pulse_validate"]
    ...
```

老测试可能写成 `monkeypatch.setattr(pulse_io, "_pulse_validate", spy)` —
但 run_eval 查的是 pulse_eval 命名空间,patch 在 pulse_io 上**无效**。
测试必须 patch 在使用处:

```python
monkeypatch.setattr("pulse_eval._pulse_validate", spy)  # ✓ 影响 run_eval
# 不是
monkeypatch.setattr("pulse_io._pulse_validate", spy)    # ✗ silently no-op for run_eval
```

PULSE refactor 踩过 4 个:`_pulse_validate`、`_parse_pulse_md`、
`_TS_RE`、`PULSE_DIR`。修法都一样 — 把 patch target 从
`<原 module>.X` 改成 `<lookup site module>.X`。

补救:如果原模块里 caller 写的是 `import server; server.foo()`(模块属性查找),
patch `server.foo` 仍然有效。所以 G1 第二行的"top-level `import X`,
call site 写 `X.foo()`"对**保留可 patch 性**很重要 —
`from X import foo` 等于把测试入口切断了。

Real Python "Python Mock Library Reference" 第 5 节
"Patching the Object's Attribute" 把这个反复讲。

---

## G4 — Cross-module fixture: patch all module copies of a constant

G2 + G3 的合并后果:一个 Path / config 常量被 N 个模块 `from server import` 走,
N 个绑定,fixture 必须遍历:

```python
import importlib

@pytest.fixture
def isolated_pulse_dirs(tmp_path, monkeypatch):
    eval_dir = tmp_path / "eval"
    state_dir = tmp_path / "state"
    eval_dir.mkdir()
    state_dir.mkdir()

    # 抽出过程中模块可能尚未存在 — raising=False 兼容中间阶段
    for mod_name in ("server", "pulse_io", "pulse_eval", "pulse_evolve", "pulse_routes"):
        try:
            mod = importlib.import_module(mod_name)
        except ImportError:
            continue
        for attr, val in (
            ("EVAL_LOG_DIR", eval_dir),
            ("PULSE_STATE_DIR", state_dir),
            ("PULSE_DIR", tmp_path),
        ):
            if hasattr(mod, attr):
                monkeypatch.setattr(mod, attr, val, raising=False)

    yield tmp_path
```

关键点:

- **`raising=False`**:在 LARGE refactor 中段,有些模块可能还没抽出,跑全套测试时
  ImportError 不该挂。`raising=False` 让 `setattr` 在属性不存在时静默跳过(配合
  `hasattr` 检查)。
- **遍历 server 自己**:别忘了 server.py 也有一份。
- **importlib 不用 `from X import X`**:fixture 本身不该把这些模块的"当前状态"
  固化进自己的命名空间(否则 fixture 自己又多一份要 patch 的副本)。

---

## G5 — Lambda closure captures module globals (subtle)

```python
# server.py(抽出前)
_USER_PULSE_PATH = Path("...")
_SELF_EVOLVE_TARGETS = {
    "user_pulse": {"path": lambda: _USER_PULSE_PATH},
}
```

lambda 捕获的是**定义所在模块**的 `_USER_PULSE_PATH` 名字,不是值。抽到
pulse_io.py 后,lambda 解析 `_USER_PULSE_PATH` 走的是 `pulse_io.__dict__` →
`pulse_io.__globals__["_USER_PULSE_PATH"]`。

后果:

```python
# 抽出后,这个 patch 不再影响 lambda(lambda 看 pulse_io 那份)
monkeypatch.setattr(server, "_USER_PULSE_PATH", tmp_path)  # ✗

# 这个才行:patch lambda 的查找目标
monkeypatch.setattr(pulse_io, "_USER_PULSE_PATH", tmp_path)  # ✓

# 或者 patch dict item 整个换掉 lambda:
monkeypatch.setitem(
    server._SELF_EVOLVE_TARGETS["user_pulse"],
    "path",
    lambda: tmp_path,
)  # ✓ 更直接 — 见 G2
```

为什么:Python 的 closure 是 lexical(基于源码位置),但自由变量
(non-local 且非 enclosing function 局部的)走 `func.__globals__`
查找,而 `__globals__` 就是**函数定义所在模块的 module dict**。
抽出时函数迁了模块,`__globals__` 跟着迁。

CPython implementation detail:`lambda.__globals__ is <defining_module>.__dict__`。
verify 一行:`assert _SELF_EVOLVE_TARGETS["user_pulse"]["path"].__globals__ is pulse_io.__dict__`。

---

## See also

- refactor-extract.md — main playbook (language-agnostic doctrine)
- test-refactor.md — characterization tests + cold-boot + adversarial expansion
- ctrl-c-v § 9 — extraction sizing & commit strategy
- Python docs: [unittest.mock — Where to patch](https://docs.python.org/3/library/unittest.mock.html#where-to-patch)
- Python docs: [The import system](https://docs.python.org/3/reference/import.html)
- PEP 328: [Absolute and relative imports](https://peps.python.org/pep-0328/)
- Real Python: "Python Mock Library Reference" / "Mocking External APIs in Python"
