# Refactor: Extract Module — playbook

ctrl-c-v § 9 mode 的执行细节。每步对应一个经典 idiom,
citing classic 而非 reinvent。

> Python flavor 的散落坑(lazy import / dict-setitem 隐式 re-export /
> setattr 副作用)单独走 [refactor-extract-python.md](refactor-extract-python.md)。

## Pre-flight: when does this playbook apply?

- LARGE refactor only — 拆模块、跨文件搬运、改 import 拓扑
- Boy Scout-sized cleanup(单文件内 rename、抽 helper)→ 直接做,别开本 playbook
- 触发线:Fowler Refactoring 2e 序言 — "restructuring **without changing
  external behavior**"。一旦改了 caller 看到的语义,这不再是 refactor,是 rewrite
- 前提:存在 caller 你不能一次改完(下游 repo / 别的服务 / public API)。
  能 atomic 改完的 → 直接改,跳本 playbook
- 准备:Klein 2007 HBR pre-mortem 5 分钟 — "假设这次拆完 caller 全炸,为什么?"
  能立刻答出 3 条以上,先 Mikado(Brolund 2010) 画依赖再动手

## Step 1 — Find the seam (Feathers Ch.4 + Metz POODR Ch.9)

Feathers Ch.4 定义 seam = "a place where you can alter behavior without
editing in that place"。Metz POODR Ch.9 看 fan-in/fan-out:
**fan-in 高的接口先抽**(很多人依赖 = 契约已稳定),fan-out 高的先别动。

| Stack  | Command |
|---|---|
| Python | `rg -n "from foo import|import foo" --type py \| wc -l` |
| Rust   | `cargo modules generate tree --with-uses \| grep foo::` |
| Go     | `go mod why -m ./...` + `grep -rn '"myrepo/foo"' --include='*.go'` |
| TS     | `rg -n "from ['\"].*foo['\"]" --type ts` |
| Java   | `mvn dependency:tree \| grep com.example.foo` |

fan-in > 10 = 这是 seam,从这里抽。fan-in ≤ 2 = 还没到拆模块的时候。

## Step 2 — Lock behavior (characterization tests, → ctrl-c-v-tdd § T7)

Feathers Ch.13 — characterization test (mnemonic: GREEN-LOCK) 记录当前行为
**不论它对不对**,refactor 期间这层网兜底。配套技术 Llewellyn Falco /
Emily Bache 的 Approval Tests / Golden Master 适合输出复杂的场景。

具体怎么写、Meszaros xUnit Test Patterns 2007 的 Dummy/Stub/Spy/Mock/Fake 怎么挑、
Fowler 2007 "Mocks Aren't Stubs" + GOOS 2009 "mock roles, not objects" 的边界,
→ 见 `~/.claude/skills/ctrl-c-v-tdd/playbooks/test-refactor.md`,本文件不重复。

红线:Step 3 之前必须 GREEN。一个 characterization 都没写就动结构 = 裸奔。

## Step 3 — Extract preserving caller signatures (Parallel Change, Sato 2014)

Sato 2014 "Parallel Change" (aka Expand-Contract):
**expand** 新位置 → **migrate** caller → **contract** 删旧位置。
本步只做 expand:新模块上线,旧位置保留 re-export shim,caller 一行不动。
搭配 Fowler 2004 "Strangler Fig" 思路:新树长在旧树外面,慢慢勒死旧的;
模块级抽象层用 Hammant 2007 "Branch by Abstraction" + Humble & Farley CD
2010 Ch.13。

Python(注意散落坑见 [refactor-extract-python.md](refactor-extract-python.md)):
```python
# old/foo.py
from new.foo import bar, Baz, FOO_CONST  # re-export shim
```

Rust:
```rust
// old/foo.rs
pub use crate::new::foo::{bar, Baz, FOO_CONST};
```

Go(internal/ 套路):
```go
// old/foo/foo.go — keep package name, re-export
package foo
import newfoo "myrepo/internal/newfoo"
var Bar = newfoo.Bar
type Baz = newfoo.Baz
```

TS(barrel re-export):
```ts
// old/foo/index.ts
export { bar, Baz, FOO_CONST } from "../new/foo";
```

Java(multi-module Maven/Gradle):
```java
// old/Foo.java — facade delegates
public class Foo { public static String bar() { return new.Foo.bar(); } }
```

铁律:caller 的 import 一字不改。改了 = 不是 Parallel Change,
是一次性大爆炸 refactor,Sato 论文要的就是避免这个。

## Step 4 — 3-tier verify (Cohn Test Pyramid + Humble CD Ch.5)

Cohn 2009 Succeeding with Agile Ch.7 Test Pyramid:unit / integration / e2e
三层都跑过 GREEN,缺一层就有 caller 看不见的回归。

```
unit            → 新模块自己的 test
integration     → 旧位置 import 路径仍 work(Step 3 shim 在不在)
e2e             → 端到端 smoke,Humble & Farley CD 2010 Ch.5 "commit-stage smoke"
```

| Stack  | Cold-boot probe |
|---|---|
| Python | `python -c "import old.foo; print(old.foo.bar)"` — 模块 import 副作用还在? |
| Rust   | `cargo check --all-targets` — compiler 兜底 |
| Go     | `go build ./...` + `go vet ./...` — compiler + vet 兜底 |
| TS     | `tsc --noEmit && node -e "require('./old/foo')"` — 类型 + runtime 两路 |
| Java   | `mvn compile` + `Class.forName("old.Foo")` smoke |

编译型栈(Rust/Go/Java)cold-boot 大部分由 compiler 覆盖,但**动态加载 / reflection
路径仍要 e2e**。Python/TS 没编译器,显式 cold-boot probe 必跑 —
import 阶段的 side effect(setattr / register decorator)只有 import 那一刻才暴露。

## Step 5 — Stage commit (Beck Tidy First 2024)

Beck 2024 Tidy First? 核心律:**structural-only commit 和 behavioral commit
绝不混**。一个 commit 要么改结构(本 playbook 的全部步骤),要么改行为,
两者一锅炖 = code review 看不懂 = rollback 不敢动。

每阶段独立 branch + 独立 commit:
```bash
git switch -c refactor/extract-foo-step3-expand
git commit -m "refactor(foo): expand — extract to new/foo, shim re-exports (Parallel Change)"
# 验完
git switch -c refactor/extract-foo-step5-contract
git commit -m "refactor(foo): contract — remove shim after deprecation window"
```

Rollback rehearsal — 合并前在本地真跑一次 `git revert <sha> && <test>`,
Fagan 1976 software inspection 思路:**不能演练回滚的 commit 不该合**。

## Step 6 — Workspace tooling refresh

抽完模块,build 系统不知道新位置 → 跑不起来。

| Stack  | 命令 / 文件 |
|---|---|
| Python | `pyproject.toml` 加 `[tool.setuptools.packages.find]` 含新包;editable install `pip install -e .` |
| Rust   | 根 `Cargo.toml` `[workspace] members = ["crates/new-foo", ...]`;`cargo build --workspace` |
| Go     | `go.mod` 不动(同 module 内)→ 跨 module 走 `go work init && go work use ./new/foo` |
| TS     | `pnpm-workspace.yaml` 加 `packages/new-foo`;`tsconfig.json` `paths` 映射 |
| Java   | 多模块 `pom.xml` `<modules>` 加 `<module>new-foo</module>`,parent POM 继承 |

CI 也要 refresh:GitHub Actions / Jenkins / GitLab 的 path filter 多半基于
老路径,新模块不会触发 build。grep `.github/workflows/*.yml` 找 `paths:` 段补。

## Step 7 — Deprecation window for the re-export shim

Sato 2014 Parallel Change 的 **contract** 阶段。shim 不能永留 —
留 = caller 永远不迁,你白拆了。Hammant 2007 Branch by Abstraction
讲到这一步:删抽象层,只留新实现。

| Stack  | Deprecation marker |
|---|---|
| Python | `import warnings; warnings.warn("old.foo moved to new.foo", DeprecationWarning, stacklevel=2)` |
| Rust   | `#[deprecated(since = "1.4.0", note = "use new::foo instead")] pub use ...` |
| Go     | `// Deprecated: use myrepo/internal/newfoo. Will remove in v2.0.` (godot / golangci-lint `staticcheck SA1019` 抓 caller) |
| TS     | `/** @deprecated use ../new/foo */ export { bar } from "../new/foo";` (tsc + eslint `deprecation/deprecation`) |
| Java   | `@Deprecated(since = "1.4", forRemoval = true)` — `javac` 跨 module 自动告警 |

Window:1-2 个 release。第 3 个 release 前 grep 全 repo 确认 0 caller,删 shim。
caller 在外部 repo 跑不到 → Mikado(Brolund 2010) 列依赖图,挨个 PR。

## Anti-patterns

Refactor-specific 子集,见 ctrl-c-v Quick ref 完整表。

| Wrong | Right |
|---|---|
| Read it, redesign "cleaner", rewrite | Fowler 2e 序言:behavior 不变;先 characterization test 再动手 |
| 一个 commit 里又拆又改逻辑 | Beck 2024:structural / behavioral 拆两个 commit |
| 直接改 caller 的 import 路径 | Sato 2014 Parallel Change:expand → 留 shim → contract |
| 抽完不写 deprecation | shim 永留 = caller 永不迁 = 白拆;`@deprecated` 给迁移压力 |
| 只跑 unit test 就合 | Cohn Test Pyramid 三层全跑;Python/TS 额外 cold-boot probe |
| 不看 fan-in 凭直觉拆 | Metz POODR Ch.9:fan-in 高的先抽;低的等契约稳了再说 |
| 没 characterization 网就动结构 | Feathers Ch.13 必须先 GREEN;Approval Tests 适合复杂输出 |
| 一次性勒死旧实现 | Fowler 2004 Strangler Fig + Hammant 2007 Branch by Abstraction:并存,慢慢迁 |
| 跨 repo caller 不画依赖图直接动 | Brolund 2010 Mikado:画完图再动,叶子节点先动 |
| 不演练 rollback 就合 | Fagan 1976 inspection:本地 `git revert` 跑过测试再合 |
