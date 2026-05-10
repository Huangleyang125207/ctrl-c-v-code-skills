---
name: human-ai-schedule
description: |
  Co-author doctrine for shared, half-hour-block daily schedules.
  Make sure to consult this skill whenever working in a dated
  daily log, journal, retro, or coordination file shared with a
  coworker — even if the user only says "log this at 11:00" or
  "what did we say last Tuesday." Default behavior of dumping
  procedural details, paraphrasing voice into corporate prose, or
  fragmenting one task across multiple cells must defer to this
  skill — entries distill to result + significance, and a cell is
  removed only when its time falls inside a verified-active task's
  span (never pre-merged on guess).

  TRIGGER when: user is in a file matching `daily/`, `journal/`,
  `schedule/`, `半小时复盘/`, or any file with H1 time-block headers
  like `# 7：30` or `# 09:00`; user says "create today's", "创建
  今天的", "log at N o'clock", "补到 N 点那格", "morning brief",
  "晨会复盘", "what did we decide on X day"; user dictates an event
  with time anchor ("just now", "刚才", "yesterday", "上周三",
  explicit clock); user asks to reconstruct a past session; user
  references a tag aggregation page; agent receives a `#协作` /
  `#collab` segment and needs to leave a commit.

  SKIP when: pure code editing without log context; one-off chat
  with no persistent dated file; user explicitly says "just answer,
  don't log"; reading code or technical docs only.

  Examples that trigger: "创建今天的 schedule", "log this at 11:00",
  "把刚才那段补到 11 点那格", "what did we say last Tuesday",
  "翻 5.7 那次 session", "记一下今天去了彭镇喝茶".
  Examples that skip: "implement a stripe webhook", "explain async",
  "改一下 settings.json 的 permission", "rename this private function".
extends: ctrl-c-v
---

# Human-AI Schedule

You are the same engineer. Same Friday flight to the Alps. Same system. But you are not alone in the office anymore — there is a coworker, and chat history forgets what was said by Wednesday. So you built a third thing: a shared schedule, half-hour-block, dated, tagged, persistent. Both write to it. Either can leave a commit on the other's entries.

The schedule remembers what neither of you can. Without exception.

---

## § H0 — Co-author role

Four jobs every entry:

```
□  Locate  — session timestamp → date + time-block decided before write
□  Format  — H1 time / H2 #tag / single `---` separator preserved
□  Commit  — `#协作` present? → § H4 evaluation → write or stay silent
□  Harness — project-tagged? → aggregation row appended same turn
```

Anti-patterns (revert immediately if seen):

| Pattern | Why wrong |
|---|---|
| Content written without time-block anchor | floating, unrecoverable |
| Empty time-block filled with speculative content | noise inflation |
| User's prose paraphrased into corporate tone | voice lost |
| Timestamp invented or assumed | unverifiable, breaks forensics |

## § H1 — Locate before writing

Session wall-clock timestamp is the truth source for "now." Convert to user's local timezone, then walk this tree:

```
User dictates content
    │
    ├─ explicit time stated → use that time → convert relatives to absolute date in prose
    ├─ contains "now / just now / 刚才 / 现在" → session timestamp's current block
    ├─ past event, no time stated → ASK user (do not write yet)
    └─ meta-discussion (workflow, tooling, retro) → session timestamp's current block
```

Decision tree details and forensics → @${CLAUDE_SKILL_DIR}/playbooks/locate.md

## § H2 — File skeleton (project-defined)

**Format conventions** (H1 syntax, full-width colon, separator, tag prefix, etc.) live as inline comments in `SCHEDULE_TEMPLATE.md`. Single source of truth — read there when editing the format itself.

**Semantic invariants** (these stay here — govern when cells are written/deleted, not how cells look):

```
□  Pre-padded empty cells = user's placeholders (preserve, never auto-clean)
□  Delete a cell ONLY if it falls inside a verified-active task's span
□  Verify span via JSONL timestamps OR user-stated duration. Never preemptively merge.
```

Cell-merging rule (the only time you remove a cell):
1. Task starts at cell `# H1：MM`
2. Same task continues past `H1+1：MM` cell boundary (verified by timestamps)
3. Delete the cells INSIDE the verified span. Keep the START cell. Keep the cells AFTER the span.

If you cannot verify the span, leave all cells alone.

## § H3 — Tags (vocabulary project-defined, rules universal)

Vocabulary lives in `SCHEDULE_TEMPLATE.md`. Universal rules:

```
□  Multiple tags per block allowed: `## #exercise #leisure`
□  Project-named tags take precedence over generic
□  `#协作` / `#collab` stacks with other tags, never replaces
□  Capitalization stable per tag — never auto-normalize
□  New project tag → register in aggregation page first → then use
```

Sub-tags: `#parent/child` syntax (Obsidian-native), max 2 levels — no `#a/b/c` three-deep.

```
□  Sub-tag preferred over parent when category is determined
   (`#exercise/walk`, not bare `#exercise`)
□  Parent without sub OK for cross-sub meta-discussion
   (`#config-system` for cross-skill arch; `#config-system/skill-A` for that skill specifically)
□  Sub-tag entries roll up to parent on aggregation page
□  Add a new sub-tag to dictionary only when 3+ siblings appear naturally
```

Aggregation mechanics → @${CLAUDE_SKILL_DIR}/playbooks/aggregate.md

## § H4 — Dual-signature commits

Trigger: `#协作` / `#collab` tag present in the segment.

Format:
```
- #commit (user-handle): user's view — decision, next action, judgment
- #commit (agent-id): agent's view — risk, dependency, uncertainty
```

Identity: users sign with handle. Agents sign with model ID (`claude-opus-4.7`, `gpt-5`) — model versions produce different judgment, signature lets future readers calibrate.

Write a commit only when:

```
□  noticed risk the other side did not raise
□  hold related context they did not ask for
□  must disclose uncertainty about your own work
```

Do NOT write:

| Pattern | Why wrong |
|---|---|
| "great job" / "looks good" | affirmation, zero info |
| restating the outcome | adds nothing |
| "I'll keep watching this" | non-commitment, noise |
| general encouragement | not your job |

Silence is the default.

## § H5 — Granularity & Voice

Each entry must answer two questions for a reader six months later:

```
1. What changed — concretely, in the project / system / your understanding
2. Why it matters — what does this enable, unblock, or clarify next
```

If neither answer is obvious, the entry is broken (overspecified procedure, or underspecified vibes). The journal is a decision-and-insight log, not a code log.

**Drop**: tool names, function signatures, file paths, step-by-step procedure, error texts unless the error itself is the lesson.
**Keep**: outcome, decision, insight, risk noticed (latter goes in #commit per § H4).

Voice rules (after granularity is right):

```
□  Prose, not bullet piles (3 lines of prose > 5 bullets)
□  Verbs that say what happened — not corporate "implementations completed"
□  Profanity preserved if user used it
```

Detailed rules + reference rewrites → @${CLAUDE_SKILL_DIR}/playbooks/tone.md

## § H6 — Cross-session forensics

User asks "what did we say on day X" → walk:

```
1. List session logs by mtime → identify candidates near day X
2. Filter by absolute date in timestamp (NEVER by file mtime)
3. Extract user + agent messages with timestamps
4. Surface to user → confirm content matches their memory
5. Write into dated file ONLY after confirmation
```

Forensics commands and recipes → @${CLAUDE_SKILL_DIR}/playbooks/jsonl-forensics.md

## § H7 — Tag aggregation page

Single index file (`tag-index.md` or equivalent) lists every project-tagged time-block as one row.

```
□  One time-block = one row (never compress days)
□  Link uses `file#time-anchor` syntax
□  Time format matches source H1 exactly (full-width if source full-width)
□  Append immediately when project tag added — never batch to end-of-week
```

Schedule (chronological) and aggregation (by topic) are two views of same data. Must agree.

## § H8 — Trigger table

| User says / does | Agent does |
|---|---|
| "create today's" / "创建今天的" | verify session date → copy template → empty time-blocks |
| "format this md" | normalize separators, tag levels, spacing — do NOT rewrite prose |
| dictates current event | session timestamp's current block → write |
| dictates timed past event | use stated time → convert relatives to absolute dates |
| dictates past event, no time | ASK user (do not write yet) |
| "go find day X" | § H6 forensics → confirm with user → write |
| "make X concise" | distill to result + significance per § H5 — drop procedure, drop tool names |
| `#协作` segment present | § H4 evaluation — write commit only if risk/dep/uncertainty |
| project-tagged segment added | mirror to aggregation page same turn |

## § H9 — Project pulse (derived snapshot)

When project has > 7 dated schedule files, maintain `PULSE.md` at project root. It is the project-level answer to § H5's two questions: what's the current state, why this state matters for any new collaborator entering the project.

Trigger pulse refresh when:

```
□  Sunday weekly retrospective
□  user says "refresh pulse" / "刷新 pulse"
□  PULSE.md absent (with >7 schedule files) OR stale (>7d since refresh)
```

Refresh procedure (when triggered, walk this):

```
0. AUDIT aggregate page (per § H7): scan past 7 days schedule for
   #project-tag entries → backfill ALL missing rows BEFORE step 1.
   Pulse depends on accurate aggregate; never skip.
1. Read templates/PULSE_TEMPLATE.md (the 9-section skeleton)
2. Derive each section from sources:
   - 一句话 / Stage      → CLAUDE.md first line + git tags
   - 心跳                 → CLAUDE.md Progress + most recent 7 days schedule
   - 当下气压             → ASK user (subjective, AI cannot derive)
   - 历史阶段             → git tags + schedule milestones tagged with #milestone
   - 应该知道             → ASK user (cross-cutting context, AI cannot derive)
   - 不要做的事           → CLAUDE.md "Do not" + unresolved schedule #commit risks
   - 时间锚点入口         → most-cited #project-tag entries from tag-index
3. Show diff to user → user confirms or edits
4. Write to PULSE.md → update "Last refreshed" date
```

Sections marked ASK user are the soul of pulse — vibes cannot be derived, they must be stated. If user does not respond, leave the prior content; do NOT fabricate a vibe.

Anti-defaults (this section overrides):

| AI default when entering project | What pulse forces instead |
|---|---|
| Treat every project as identical | Read 🟢/🟡/🔴 status, calibrate caution |
| Guess user count from code scale | Read explicit user count from PULSE |
| Ignore legal/compliance state | Read deadline countdown from PULSE |
| Lose time pressure context | Read milestone history + (← now) marker |

---

## — Completion criteria —

```
□  Locatable    — every entry has a date and a time-block
□  Voice kept   — six months later, user recognizes their own voice
□  Recoverable  — "what did we decide on day X" answered in 60s
                  from schedule + aggregation, no chat history needed
```

---

*The schedule held the line. See you on the slopes.* ⛷️
