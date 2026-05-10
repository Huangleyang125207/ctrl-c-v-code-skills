# human-ai-schedule

> **Co-author doctrine for shared, half-hour-block daily schedules.**
> Place user utterances into the correct day file + correct time-block
> using the session JSONL timestamp as the time-of-truth. Distill
> entries to result + significance, never procedure dump. Maintain a
> tag aggregation index. Optionally derive a project-level `PULSE.md`
> snapshot weekly.

Third skill in the bundle. Same engineer, same Friday Alps — but you
are not alone in the office anymore. Chat history forgets what was
said by Wednesday. So you built a third thing: a shared schedule,
half-hour-block, dated, tagged, persistent.

> ⚠️ **PULSE.md mechanism (§ H9) is v1, not yet dogfooded** in any
> real project. Treat as draft until first refresh cycle proves the
> derivation procedure.

## When this activates

- User is in a file matching `daily/`, `journal/`, `schedule/`,
  `半小时复盘/`, or any file with H1 time-block headers like
  `# 7：30` or `# 09:00`
- User says: "create today's", "创建今天的", "log at N o'clock",
  "补到 N 点那格", "morning brief", "晨会复盘", "what did we decide
  on X day"
- User dictates an event with time anchor ("just now", "刚才",
  "yesterday", "上周三", explicit clock)
- User asks to reconstruct a past session
- User references a tag aggregation page
- Agent receives a `#协作` / `#collab` segment and needs to leave a commit

## When it doesn't

- Pure code editing without log context (use ctrl-c-v)
- One-off chat with no persistent dated file
- User explicitly says "just answer, don't log"
- Reading code or technical docs only

## Sections in SKILL.md

Read [`skills/human-ai-schedule/SKILL.md`](../skills/human-ai-schedule/SKILL.md):

| § | What | Playbook |
|---|------|----------|
| H0 | Co-author role (4 jobs: locate / format / commit / harness) | — |
| H1 | Locate before writing (JSONL timestamp decision tree) | `locate.md` |
| H2 | File skeleton (project-defined; cell = task boundary) | — |
| H3 | Tags (vocabulary project-defined, sub-tag rules universal) | — |
| H4 | Dual-signature commits in `#协作` paragraphs | — |
| H5 | Granularity & Voice (result + significance, not procedure) | `tone.md` |
| H6 | Cross-session forensics (jq commands + 2-step confirmation) | `jsonl-forensics.md` |
| H7 | Tag aggregation page (write-back rules) | `aggregate.md` |
| H8 | Trigger table ("user says X → agent does Y") | — |
| H9 | Project pulse (weekly derived snapshot) — v1 | — |

## Examples

**Triggers**:

```
"创建今天的 schedule"
"log this at 11:00"
"把刚才那段补到 11 点那格"
"what did we say last Tuesday"
"翻 5.7 那次 session"
"记一下今天去了彭镇喝茶"
```

**Skips**:

```
"implement a stripe webhook"
"explain async"
"改一下 settings.json 的 permission"
"rename this private function"
```

## Sub-tag system (§ H3)

```
□  #parent/child syntax (Obsidian-native), max 2 levels
□  Sub preferred over parent when category is determined
   (#exercise/walk, not bare #exercise)
□  Parent OK for cross-sub meta-discussion
   (#config-system for cross-skill arch)
□  Sub-tag entries roll up to parent on aggregation page
□  Add new sub only when 3+ siblings appear naturally
```

## Anti-patterns

| Doing this | Do this instead |
|---|---|
| Content placed without time-block anchor | Snap to JSONL-timestamp current block |
| Empty time-block filled with speculative content | Leave empty (placeholder) |
| User's prose paraphrased into corporate tone | Preserve voice, even profanity |
| Procedure dump as entry body | Distill to "what changed" + "why it matters" |
| Pre-merging cells on guess | Merge only inside verified-active task span |
| Affirmation #commit ("looks good") | Silence is the default |
| Project-tagged segment without aggregation row | Same-turn write-back |

## Templates

```
templates/SCHEDULE_TEMPLATE.md   blank day skeleton (7:30 → 23:00)
templates/AGGREGATE_TEMPLATE.md  blank tag-aggregation table
```

## PULSE.md (§ H9, draft)

Project-level vibe snapshot derived weekly. Refresh procedure starts
with **audit aggregation page first** (Step 0), then derives 9 sections
from CLAUDE.md / git tags / schedule history / `ASK user` for vibes.

`templates/PULSE_TEMPLATE.md` is the 9-section skeleton. ctrl-c-v
`§ 0` reads PULSE.md if present and flags stale (>7 days).

## Files in this skill

```
skills/human-ai-schedule/
├── SKILL.md
├── playbooks/
│   ├── locate.md
│   ├── tone.md
│   ├── jsonl-forensics.md
│   └── aggregate.md
└── templates/
    ├── SCHEDULE_TEMPLATE.md
    └── AGGREGATE_TEMPLATE.md
```

Top-level template: `templates/PULSE_TEMPLATE.md`.
