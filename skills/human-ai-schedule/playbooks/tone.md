# Playbook: Granularity & Tone

> Loaded by § H5.

## The 1-year test (primary rubric)

> Glance at this entry 12 months from now for 5 seconds. Do you still know what happened that day?

This is the only test that matters. Everything below is consequence of failing it.

If yes → keep.
If no → almost always the failure is **procedure leakage**: version numbers, tool names, file paths, library names, API endpoints, line counts. All decay to noise within months.

Derived rubric — every entry must answer:

```
1. What changed   — concretely, in the project / system / your understanding
2. Why it matters — what does this enable, unblock, or clarify going forward
```

If neither answer is obvious to a 12-month-later reader, the entry is broken — either overspecified (procedure leaked through) or underspecified (vague feel-words).

The journal exists for **future-you reading 12 months later**, not for the writer's present moment of working through something. The writer remembers everything; the reader has zero context.

**Hard banned vocabulary** (delete on sight when reviewing your own entry):
- Version numbers: `v0.4`, `v0.4.1`, `第三版`
- Tool / lib / API: `FastAPI`, `DeepSeek`, `chokidar`, `widget-loader.js`
- File paths: `shared/journal.js`, `scripts/X.sh`
- Endpoint / function names: `/api/journal/today`, `patch_journal_block`
- Pure status notes: "没真测过", "下次再调", "x 行代码"

## Anti-pattern: procedure dump

The most common failure mode — describing what was done step-by-step instead of what changed and why.

| ❌ Procedure-heavy | ✅ Result + meaning |
|---|---|
| 用 worktree 拉了 origin/main 分支，把 ctrl-c-v-tdd 整套（SKILL.md + 6 playbooks + 5 seed pattern + hook 脚本）嵌进 skills/ctrl-c-v-tdd/ 子目录对齐 ctrl-c-v 嵌套结构，plugin.json skills[] 从 1 项扩到 2 项... | ctrl-c-v + ctrl-c-v-tdd 作 sub-skills 推上 GitHub。**意义**：coding 教义不再绑在这台机器，能分发给别人装。 |
| 重写 description 加上 pushy 语气和反训练锚，按 skill-creator 的 7 条规则做 TRIGGER/SKIP 双轨结构，TDD 那段嵌入 "Saturday phone call" 叙事钩... | Skill description 写法对齐了官方规则。**意义**：description 是 skill 唯一的触发入口，写不好就漏激活——以后写 skill 直接套这个框架。 |
| 跑了 jq 把 .skills 数组追加一项，路径写 skills/human-ai-schedule/SKILL.md，keywords 加了 journal/retrospective/co-authorship 三个 | 半小时复盘协议自身 skill 化。**意义**：这套日记体系不再绑当前项目，任何 cwd 都能自动激活。 |

**Drop unconditionally**:
- Tool names (`worktree`, `jq`, `grep`)
- Function signatures, paths, args
- Step-by-step "first I did X, then Y, then Z"
- Error texts (unless the error itself is the lesson)

**Keep**:
- The outcome (what's now different)
- The significance (why future-you cares)
- A risk or uncertainty if you noticed one (goes in #commit per § H4)

## Voice rules (secondary, applied after granularity is right)

Once you've cut to result + significance, voice still matters — diary register, not corporate prose.

```
□  Prose, not bullet piles (3 lines of prose > 5 bullets)
□  Verbs that say what happened — not "implementations completed"
□  Profanity preserved if user used it
□  Casual register matches the diary genre
```

| ❌ Corporate | ✅ Diary voice |
|---|---|
| 实现 X 功能 | 卧槽老子搞定了 |
| 完成标签管理体系 | 标签格式终于统一了 |
| 进行了产品讨论 | 跟设计师扯了一上午原型 |

## Concise ≠ Compressed

- **Concise** = one sentence covers result + significance, voice intact
- **Compressed** = three sentences squeezed into one bullet, voice stripped

Diary should be concise. Never compressed.

## Absolute date rule

Body text must spell out absolute dates for any "yesterday / 昨天 / 上周 / 前天" reference.

```
❌ "昨天去吃了内江牛肉面"
✅ "5.6 去新津吃了内江牛肉面"
```

JSONL timestamp is "when message was sent," not "when event happened." Future recall depends on absolute dates being inline. **Non-negotiable.**

## When user says "make this concise"

Apply the two-question test:

1. Strip the procedure prose
2. Distill to: what changed + why it matters
3. Voice rules still apply (no compression to bullets)

The user didn't ask for less voice. They asked for less noise.

## Sample rewrite (full entry)

❌ Before:
```
## #projectA #collab TDD 反训练锚 + skill-creator 官方规则深读

TDD 描述继续磨——指出 "Tests are copyable from..." 只是位置说明
不是行为指令，要补 bias override 跟 ctrl-c-v 的 "copy beats
compose" 对仗。然后干脆把 skill-creator 完整 SKILL.md 通读，7
条规定贴出来：description 是唯一触发机制、要 pushy 对抗 LLM
undertriggering、~100 词参考、eval 集 8-10 正 + 8-10 反、
queries 必须真实带 backstory 等。重写两段——TDD 那段嵌入
"Saturday phone call" 叙事钩...
```

✅ After:
```
## #projectA #collab 学会 skill description 写法

之前以为 description 就是个简介，今天搞清楚它是 skill 唯一的
触发入口，写不好根本不激活。建立了"pushy 语气 + 反训练锚 +
TRIGGER/SKIP 双轨 + 真实 examples"的写作框架。**意义**：以后
写 skill 不再瞎写 description，有官方规则当靠山。
```

What was kept: the insight ("description 是触发入口"), the now-reusable framework, the significance.
What was dropped: which rules specifically (~100 words / eval split / etc.), the Saturday call narrative, the bias-override wording.
