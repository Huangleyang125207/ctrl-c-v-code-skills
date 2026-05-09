# Playbook: Tone

> Loaded by § H5.

## Four anti-AI principles

### 1. Bullet density low

Diary text is prose. AI default is bullet lists. Resist.

| ❌ AI default | ✅ Diary voice |
|---|---|
| - 完成 ICP 备案<br>- 提交了营业执照<br>- 等待审核回复<br>- 域名 DNS 已切换<br>- 准备下一步 | 早上去工商扫了营业执照，11 点前提交了 ICP，DNS 切了，就等审核回。 |

3 lines of prose > 5 bullets when the events are connected.

### 2. Verbs present, not abstracted away

Diary records doing, not "having done." Verbs carry energy.

| ❌ AI default | ✅ Diary voice |
|---|---|
| 实现 X 功能 | 卧槽老子搞定了 |
| 完成标签管理体系 | 标签格式终于统一了 |
| 进行了产品讨论 | 跟设计师扯了一上午原型 |

If the entry could appear unchanged in a corporate quarterly, it has lost voice.

### 3. Cause / blocker / outcome shape

Three-paragraph form for any reflection-class entry:

```
起因 / 触发场景：今天做这件事是因为...
经过 / 卡点：中间发现...
结果 + 遗留：搞定了 X，但 Y 没解决，下次怎么办
```

Without the cause and blocker, the outcome is decontextualized — six months later the user reads "完成 ICP 备案" and wonders why it was hard.

### 4. Profanity preserved

If the user wrote "卧槽" or "fuck" in their dictation, it stays. AI default is to sanitize. Sanitization erases the moment.

## Concise ≠ Compressed

Concise = one sentence covers three ideas, **voice intact**.
Compressed = three sentences squeezed into one bullet, **voice stripped**.

Diary should be concise. Never compressed.

## Absolute date rule

Body text must spell out absolute dates for any "yesterday / 昨天 / 上周 / 前天" reference.

```
❌ "昨天去吃了内江牛肉面"
✅ "5.6 去新津吃了内江牛肉面"
```

Why: JSONL timestamp is "when message was sent," not "when event happened." Future recall depends on absolute dates being inline. **Non-negotiable.**

## When user says "make this concise"

Do NOT compress to bullets. Apply three-paragraph form (cause / blocker / outcome). The user wants signal-to-noise up, not voice removed.

## Reference rewrites

| Source (raw user dictation) | After tone-pass |
|---|---|
| 今天上午跟设计师讨论了 ICP 备案的 banner 该怎么放 | 上午跟设计师扯 ICP banner 摆哪——他想放顶部右上角，我觉得太显眼 |
| 完成域名 DNS 解析切换 | DNS 切了，等运营商缓存过期再验 |
| 修复了登录页的样式问题 | 登录页那个 padding 错位的 bug 终于找到了：z-index 串了 |
