# CLAUDE.md — [PROJECT NAME]

[One line. What this project is.]

Tech: [language] · [framework] · [key libs]

---

## Progress

- [x] [Done item] (abc1234)
- [x] [Done item] (def5678)
- [ ] [Next]
- [ ] [Later]

Update this list after every commit.

## References (load when needed, not before)

| When I'm working on... | Load |
|---|---|
| UI / layout / styling | @design.md |
| Charts / visualization | @charts/ file headers |
| API / third-party integration | @docs/api-endpoints.md |
| Dependencies / what's approved | @docs/approved-deps.md |

Do not load references preemptively. Load when the task touches that area.

## Project rules (always active)

- All colors/fonts/spacing: reference `utils/design.py` constants. Never hardcode
- Commit: `type(scope): what` — one line, one concern, full story
- [Rule specific to this project]
- [Rule specific to this project]
- [Rule specific to this project]

## Do not

- [Thing that has caused problems before in this project]
- [Thing that has caused problems before in this project]

Add to this list every time CC makes a mistake. This is the project's scar tissue.

---

## Task sizing

CC determines the size. Then follows that size's protocol. No oversizing.

**SMALL** — one file, one concern, no new patterns.
Bug fix. Label change. Style tweak. Value correction.

```
1. Read Progress in this file → confirm task doesn't duplicate done work
2. grep → fix → verify
3. Self-review diff
4. Commit → update Progress below → /clear
```

**MEDIUM** — one feature, may touch 2-3 files, copies existing pattern.
New component from template. Refactor one module. Add one chart.

```
1. Read Progress + References table → load relevant @reference
2. grep nearest pattern → copy → adapt → verify
3. Self-review diff
4. Unexpected discovery during work? → log in Findings below
5. Commit → update Progress below → /clear
```

**LARGE** — new capability, new architecture, 4+ files.
Multi-company comparison. New agent node. Tech stack migration.

```
Step 1: Read this entire file → understand current state
Step 2: Write spec in Active spec below → wait for human confirm
Step 3: Write plan below → wait for human confirm
Step 4: Break into SMALL/MEDIUM tasks → list in Tasks below
Step 5: Execute one task at a time:
        Before each task → re-read Active spec (refresh goals)
        After each task  → update Tasks checklist + Progress
        Discovery mid-task → log in Findings
        Commit after each task
Step 6: All tasks committed → delete Active spec content
```

### Size guide

| Signal | Size |
|---|---|
| "fix", "change", "update" + single file | SMALL |
| "add", "create" + similar pattern exists | MEDIUM |
| "add", "create" + nothing similar exists | LARGE |
| "refactor" + 1 module | MEDIUM |
| "refactor" + architecture / 4+ files | LARGE |
| "migrate", "redesign", "rebuild" | LARGE |
| Not sure | Ask. Don't guess the size |

---

## Active spec (LARGE tasks only)

Empty when idle. During a LARGE task, fill sections below.
Delete everything here after all tasks are committed.

### What

[3-5 lines. What this feature does. Who uses it. What "done" looks like.]

### Plan

[Files to create/modify. Which existing patterns to copy from. Risks.]

### Tasks

- [ ] T1: [SMALL/MEDIUM description] → verify: [check]
- [ ] T2: [SMALL/MEDIUM description] → verify: [check]
- [ ] T3: [SMALL/MEDIUM description] → verify: [check]

### Findings

[Unexpected discoveries during execution. Bugs found elsewhere,
architecture concerns, decisions needed, things to revisit later.
Don't interrupt current task — log here, address after current task commits.
Move resolved findings to "Do not" or delete them.]

---

## Post-commit (mandatory, every time)

```
1. Update Progress checklist (mark done, add next)
2. New mistake? → add to "Do not"
3. New reusable pattern? → save to ~/.claude/patterns/ + update INDEX.md
4. Findings need attention? → create follow-up task or add to "Do not"
5. Context long or switching tasks → /clear
```

Next session reads this file first → knows exactly where to resume.

Code has PATTERN tags. This file has progress state.
Together: complete memory. No conversation history needed.
