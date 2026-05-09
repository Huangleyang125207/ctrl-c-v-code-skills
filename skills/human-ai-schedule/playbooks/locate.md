# Playbook: Locate

> Loaded by § H1.

## Why timestamps matter

Every user message in a Claude Code session carries an ISO 8601 timestamp in the JSONL log. That timestamp is **when the message was sent**, not necessarily when the event happened. Distinguishing the two is the entire point of this playbook.

## Reading the session timestamp

Default JSONL location: `~/.claude/projects/<slug>/<session-uuid>.jsonl`. To find the latest:

```bash
ls -lt ~/.claude/projects/<slug>/*.jsonl | head -3
```

Latest user message timestamp:

```bash
jq -r 'select(.type=="user") | "\(.timestamp)  \(.message.content)"' \
  ~/.claude/projects/<slug>/<uuid>.jsonl | tail -1
```

Convert UTC to user's local timezone, then snap to the nearest preceding half-hour block. That block is "now."

## Decision tree (full)

```
User dictates content X to log
    │
    ├─ X contains explicit clock ("3 PM", "下午 3 点")
    │      → use that clock → resolve any "yesterday/上周三/前天" to ABSOLUTE date in prose
    │
    ├─ X contains "now / just now / 刚才 / 现在 / 正在"
    │      → snap to current half-hour block per session timestamp
    │
    ├─ X is past event, no time stated
    │      → ASK user. Do not write yet.
    │      → Optionally use timestamp as placeholder + annotate "[message-sent time]"
    │
    └─ X is meta-discussion (workflow, tooling improvement, retro thought)
           → snap to current half-hour block per session timestamp
           → meta event time = utterance time is reasonable
```

## Three pitfalls

**1. JSONL timestamp ≠ event time.** "Just sent at 10 AM saying I went to the noodle shop yesterday" — timestamp is 10 AM today, event was yesterday. Body must spell out the absolute date.

**2. Cross-day session.** When a single session spans midnight, filter JSONL by timestamp date (e.g., only `2026-05-08` lines), NOT by file mtime (mtime only reflects the latest write).

**3. Explicit time wins.** If user says "中午 12 点吃的面" but session timestamp is 3 PM, write 12:00. Spoken clock > log timestamp, always.

## Cross-day filter recipe

```bash
jq -r 'select(.type=="user" and (.timestamp | startswith("2026-05-08"))) | "\(.timestamp)  \(.message.content)"' \
  <session>.jsonl
```

## When you cannot locate

If the user dictation is ambiguous AND no clock + no "now" anchor — **ask, do not guess**. The cost of one clarifying question is cheap. The cost of wrong placement is invisible-until-six-months-later.
