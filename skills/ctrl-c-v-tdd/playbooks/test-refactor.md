# Refactor TDD — playbook

Characterization tests + Cold-boot tests + Adversarial test expansion.
§ T7 / § T8 的执行细节。

## When to use

LARGE refactor mode only (ctrl-c-v § 9 — restructuring, not new feature).
SMALL / MEDIUM 走 § T1 → § T0 表(SMALL → no tests; MEDIUM → 看 caller scope)。
Refactor 的 TDD 节奏跟 feature 反过来:**不是 RED → GREEN,是 GREEN-LOCK → restructure → still GREEN**
(Fowler, _Refactoring_ 2e, 2018 — 序言:"restructuring without changing external behavior";
Beck, _Tidy First?_ 2024 — structural-only commit ≠ behavioral commit,两类提交永不混)。

## Part A — Characterization tests (§ T7)

### A.1 Recipe (Feathers WELC Ch.13)

Characterization test 断**现行**行为,不是 intended 行为。先 RECORD 后 LOCK
(Falco / Bache _Approval Tests_ 风格;mnemonic: GREEN-LOCK)。Legacy monolith 没
spec、没文档、原作者跑路是常态——这时候问"它应该做什么"是问错问题,先问"它现在做什么"。

```
1. 找拆分边界 (Feathers Ch.4 Seams — 在哪里能不改 caller 把行为切开)
2. 真跑一次,把 observable output 落盘 (response body / DB row / 写出文件)
3. 该 output 作 golden/snapshot,断言下次跑还是它
4. RUN → GREEN (锁住) → 开始 refactor
5. Refactor 中任一步 RED = 行为漂了,回退或解释
```

要锁的是 **observable surface**(Falco):caller 看得见的 = HTTP response /
return value / 持久化产物 / 发出的事件。不锁:内部 method 调用次数、私有字段、
log 行(除非 log 是合同)、临时变量。Over-assert internal = 把 refactor 自己锁死。

### A.2 Per-stack examples

**Python + pytest + httpx.AsyncClient (FastAPI)**

```python
# tests/characterization/test_orders_api.py
import pytest, json
from pathlib import Path
from httpx import AsyncClient
from app.main import app

GOLDEN = Path(__file__).parent / "golden" / "orders_happy.json"

@pytest.mark.asyncio
async def test_create_order_observable_behavior():
    async with AsyncClient(app=app, base_url="http://t") as c:
        r = await c.post("/orders", json={"sku": "A1", "qty": 2})
    actual = {"status": r.status_code, "body": r.json()}
    if not GOLDEN.exists():                        # RECORD pass
        GOLDEN.write_text(json.dumps(actual, indent=2, sort_keys=True))
    expected = json.loads(GOLDEN.read_text())
    assert actual == expected                      # LOCK pass
```

**Java + JUnit 5 + @SpringBootTest + MockMvc**

```java
@SpringBootTest @AutoConfigureMockMvc
class OrdersCharacterizationTest {
    @Autowired MockMvc mvc;
    static final Path GOLDEN = Path.of("src/test/resources/golden/orders_happy.json");

    @Test void createOrder_observableBehavior() throws Exception {
        var res = mvc.perform(post("/orders").contentType(APPLICATION_JSON)
                  .content("{\"sku\":\"A1\",\"qty\":2}")).andReturn().getResponse();
        var actual = Map.of("status", res.getStatus(), "body", res.getContentAsString());
        if (!Files.exists(GOLDEN)) Files.writeString(GOLDEN, new ObjectMapper().writeValueAsString(actual));
        assertEquals(new ObjectMapper().readValue(Files.readString(GOLDEN), Map.class), actual);
    }
}
```

**Go + httptest table-driven**

```go
func TestCreateOrder_Characterization(t *testing.T) {
    cases := []struct{ name, body, golden string }{
        {"happy", `{"sku":"A1","qty":2}`, "testdata/orders_happy.json"},
        {"bad_sku", `{"sku":"","qty":2}`, "testdata/orders_bad_sku.json"},
    }
    for _, tc := range cases {
        t.Run(tc.name, func(t *testing.T) {
            r := httptest.NewRequest("POST", "/orders", strings.NewReader(tc.body))
            w := httptest.NewRecorder(); handler.ServeHTTP(w, r)
            got := fmt.Sprintf("%d\n%s", w.Code, w.Body.String())
            if _, err := os.Stat(tc.golden); os.IsNotExist(err) { os.WriteFile(tc.golden, []byte(got), 0644) }
            want, _ := os.ReadFile(tc.golden); if string(want) != got { t.Errorf("behavior drift") }
        })
    }
}
```

**Rust + axum + tower::ServiceExt::oneshot**

```rust
#[tokio::test]
async fn create_order_characterization() {
    let app = build_app();
    let req = Request::post("/orders").header("content-type","application/json")
        .body(Body::from(r#"{"sku":"A1","qty":2}"#)).unwrap();
    let res = app.oneshot(req).await.unwrap();
    let status = res.status().as_u16();
    let body = String::from_utf8(hyper::body::to_bytes(res.into_body()).await.unwrap().to_vec()).unwrap();
    let actual = format!("{}\n{}", status, body);
    let golden = std::path::Path::new("tests/golden/orders_happy.txt");
    if !golden.exists() { std::fs::write(golden, &actual).unwrap(); }
    assert_eq!(std::fs::read_to_string(golden).unwrap(), actual);
}
```

**TS + supertest + Jest**

```ts
import request from "supertest"; import fs from "fs"; import { app } from "../src/app";
test("create order characterization", async () => {
  const res = await request(app).post("/orders").send({ sku: "A1", qty: 2 });
  const actual = { status: res.status, body: res.body };
  const golden = "tests/golden/orders_happy.json";
  if (!fs.existsSync(golden)) fs.writeFileSync(golden, JSON.stringify(actual, null, 2));
  expect(actual).toEqual(JSON.parse(fs.readFileSync(golden, "utf8")));
});
```

### A.3 What a 'pin' looks like

- **RECORD pass**: 第一次跑,落 golden 文件,test 必 PASS(因为 actual = 刚写的)
- **LOCK pass**: 第二次起,actual byte-equal golden;diff = 行为漂
- **观测面**:HTTP status + body / SQL row / 发出 event / 写出文件 / stdout — 选 caller
  真的依赖的。不选:私有 method call count、log 行(除非是合同)、临时变量。
- **不锁实现细节**:别 mock 内部 service 然后 assert "ServiceX.foo() called 3 times"——
  refactor 改了调用次数但行为没变,你的 test 就是噪声(Fowler 2007 _Mocks Aren't Stubs_;
  GOOS 2009 — "mock roles, not objects",不 mock 私有协作)。
- **小 golden 优先**:一个 endpoint 一个文件,失败时人能眼读 diff。
- **Strangler Fig 节奏**(Fowler 2004):pin 一片 → 拆一片 → pin 下一片;不要一次 pin 全 monolith。

## Part B — Cold-boot tests (§ T7 续 + 跨 monolith 拆分护栏)

### B.1 Why this is the safety net

Monolith 拆分后最易漏的不是 unit-level bug,是 **import 顺序 / 循环依赖 /
副作用初始化**:Python module-level 代码、Java Spring bean init order、
Go init() 函数、Rust lazy_static、TS top-level await。unit test 早就把 module
load 完了,抓不到这些。Cold-boot = 真起 process,真发一次请求,验返期望 status
(Humble & Farley _Continuous Delivery_ 2010 Ch.5 — commit-stage smoke test;
Cohn _Succeeding with Agile_ 2009 Ch.7 — test pyramid 顶端的少量 e2e)。

Metz POODR Ch.3/9 — 拆 monolith = 改 dependency direction + 重排 fan-in/fan-out,
这恰恰是 init order 最容易暴雷的方向。一个 cold-boot smoke 比 50 个 unit test 更
能抓到"循环 import 把 / 拆成两包后就启动不了"那种事故。

### B.2 Per-stack

**Python (uvicorn)**

```bash
python -m uvicorn app.main:app --port 8765 & PID=$!
sleep 2 && curl -fsS http://127.0.0.1:8765/api/health || (kill $PID; exit 1)
kill $PID
```

**Java (Spring Boot)**

```bash
./mvnw spring-boot:run > /tmp/app.log & PID=$!
until curl -fsS http://127.0.0.1:8080/actuator/health; do sleep 1; done
kill $PID
```

**Go**

```bash
go run ./cmd/server & PID=$!
sleep 1 && curl -fsS http://127.0.0.1:8080/healthz || (kill $PID; exit 1)
kill $PID
```

**Rust**

```rust
// tests/coldboot.rs   (cargo test --release --test coldboot)
let _child = Command::new(env!("CARGO_BIN_EXE_server")).spawn().unwrap();
std::thread::sleep(Duration::from_secs(2));
assert!(reqwest::blocking::get("http://127.0.0.1:8080/healthz").unwrap().status().is_success());
```

**TS (pnpm)**

```bash
pnpm start & PID=$!
until node -e "fetch('http://127.0.0.1:3000/health').then(r=>process.exit(r.ok?0:1))"; do sleep 1; done
kill $PID
```

## Part C — Adversarial test expansion (§ T8, LARGE refactor only)

### C.1 What this composes

- **Fagan 1976** software design / code inspections — 多人独立审,rigor 来自冗余
- **Klein 2007 HBR** "Performing a Project Pre-mortem" — 时机在事前,假设已经失败再倒推
- **LLM agent fan-out** — 让 Fagan 的 rigor + Klein 的时机便宜到几分钟跑完
- **GOOS 2009** — "listen to the tests";test 写得别扭就是缺 coverage / 错抽象 的信号

### C.2 Mechanics

```
1. characterization tests + cold-boot tests 写完 → GREEN → STOP(不要开始 refactor)
2. fan-out: 跑 3-5 个独立 reviewer 各看一遍
   (并行 LLM agent / 同事 code review / coverage diff + mutation testing + linter)
3. 每 reviewer 独立提 "must-add gap"(不商量,避免 anchoring)
4. synthesizer 合并去重 → 得 candidate must-add 列表
5. skeptic agent 反证每条 must-add(真的会漏吗?golden 已经隐含覆盖了吗?)
6. 留下 confirmed must-add → 补成新 characterization tests → GREEN
7. 现在才动 refactor;每步跑全套 → 保持 GREEN
```

Parallel Change / Expand-Contract(Sato 2014)和 Branch by Abstraction
(Hammant 2007;Humble & Farley CD Ch.13)是 refactor 的搬运手法,不是 test 手法——
但它们工作的前提是上面 GREEN 一直 hold。Mikado Method(Brolund 2010)给你拆顺序,
adversarial review 给你信心说"拆完没漏行为"。

xUnit Test Patterns(Meszaros 2007)的 Dummy / Stub / Spy / Mock / Fake 分类在补
must-add 时用得上:characterization 偏 Spy(record output)+ Fake(in-memory DB),
新增的 must-add 多半也走这两类,别滑到 Mock(那是 contract test 的活)。

### C.3 Skip when

- **SMALL / MEDIUM**(ROI < 1;一个文件 refactor 不值得跑 5 个 reviewer)
- **Single-developer SMALL refactor**(没人 review,LLM fan-out 也没必要)
- **Greenfield**(没有 legacy monolith,也就没 refactor;走 § T6 LARGE feature 路径)
- **已经有完整 e2e suite + 高 mutation score**(adversarial review 边际收益 ≈ 0)

## Anti-patterns (refactor TDD 专属)

| Anti | Fix |
|---|---|
| Characterization test 一写就 fail | 你在测 **intended** 不是 **observed**——先 Approval Tests RECORD,落 golden,再 LOCK;别把"代码应该做什么"塞进 assertion |
| RED-first thinking 卡住 refactor | RED 是 feature TDD(新行为);refactor 是 characterization(GREEN-LOCK),节奏反过来——把"看到 RED 才安心"的肌肉记忆关掉 |
| 跳 cold-boot "因为 unit 全过" | unit test 不抓 import-order / init 副作用 / bean wiring;monolith 拆完必走 cold-boot 一次,几秒钟的事 |
| Adversarial review 用在 SMALL | ROI < 1;只 LARGE refactor 用,SMALL 直接 § T0 表判 no-test |
| Over-assert internal impl | golden 只锁 observable surface(Falco);锁了私有 method call count → refactor 把自己锁死 |
| Behavioral + structural 混进同一 commit | Beck _Tidy First?_:structural-only commit 单独走,behavioral 单独走;混了 review 没法读、bisect 没法定位 |
| 一次 pin 整个 monolith | Strangler Fig:pin 一片拆一片;一次性 pin 全部 → golden 文件几 MB,任一行为漂全 suite 红,debug 灾难 |
