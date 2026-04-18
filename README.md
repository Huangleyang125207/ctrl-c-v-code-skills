# Ctrl+C Ctrl+V Code Skills

**AI's biggest bug isn't wrong code — it's original code.**

90% of production software is copy-pasted from proven patterns.
This skill makes AI work the same way.

---

## The problem

AI coding agents write from scratch every time — as if no one has ever
solved a similar problem before. The result: inconsistent patterns,
duplicated functions, untested architectures, and code that works today
but breaks next Friday.

Meanwhile, the best human developers barely write original code. They grep,
copy, adapt, ship. Their codebases are searchable libraries of proven
patterns. Every comment is a search index. Every file is a self-contained
template. Every commit tells a complete story.

**This skill teaches AI to work like those developers.**

## What's in the box

| File | Purpose | Where it goes |
|---|---|---|
| `CTRL_C_V_CODE_SKILLS.md` | Global persona — how AI writes code | `~/.claude/CTRL_C_V_CODE_SKILLS.md` |
| `CLAUDE_TEMPLATE.md` | Project template — progress, references, task protocol | Copy to project root as `CLAUDE.md` |

Two files. No dependencies. No scripts. No framework.

## Install

### Option A: Claude Code plugin (recommended)

```bash
/plugin marketplace add [your-github-username]/ctrl-c-v-code-skills
/plugin install ctrl-c-v-code-skills@ctrl-c-v-code-skills
```

### Option B: Manual

```bash
# Global persona
curl -o ~/.claude/CTRL_C_V_CODE_SKILLS.md \
  https://raw.githubusercontent.com/[your-github-username]/ctrl-c-v-code-skills/main/CTRL_C_V_CODE_SKILLS.md

# Project template (copy to each project root as CLAUDE.md)
curl -O https://raw.githubusercontent.com/[your-github-username]/ctrl-c-v-code-skills/main/CLAUDE_TEMPLATE.md
cp CLAUDE_TEMPLATE.md your-project/CLAUDE.md
```

## How it works

### The persona

`CTRL_C_V_CODE_SKILLS.md` doesn't give AI a list of rules to memorize.
It gives AI an identity: a world-class engineer who has built a system
for shipping clean code effortlessly. Every behavior flows from that
identity — not from compliance, but from character.

Rules get forgotten as context grows. Identity persists.

### The copy-paste hierarchy

Before writing any code, AI walks this list top to bottom:

```
1. THIS PROJECT     grep for similar code → copy → adapt
2. FRAMEWORK        check built-in support → use it directly
3. APPROVED DEPS    check CLAUDE.md dep list → import → wire
4. TEMPLATES        check templates/ or examples/ → clone → fill
5. OFFICIAL DOCS    go to official website → find docs → copy example code
6. FROM SCRATCH     last resort → write it as a reusable template
```

Step 6 means steps 1–5 were insufficiently searched.

### Code is memory

Every function gets `PATTERN:` / `USE WHEN:` / `COPY THIS:` tags.
Next session: `grep "PATTERN: KPI"` → find it → copy it → done.

No conversation history database. No memory plugins. No bloated context.
The codebase IS the memory. Comments are the search index.

### Project auto-initialization

AI enters a project and checks: does `CLAUDE.md` exist?

- **No** → scans the project, creates `CLAUDE.md` automatically from
  `package.json`, `git log`, directory structure. Commits it.
- **Yes** → reads it, checks progress, resumes where it left off.

After every commit: updates progress, adds mistakes to "Do not" list,
clears context. Next session picks up cleanly from the file.

### Task sizing

AI determines the size, then follows the matching protocol:

| Signal | Size | Protocol |
|---|---|---|
| "fix", "change" + single file | SMALL | grep → fix → commit |
| "add", "create" + pattern exists | MEDIUM | load ref → copy → adapt → commit |
| "migrate", "redesign" + 4+ files | LARGE | spec → plan → tasks → execute |

Small tasks don't load design docs. Large tasks get a spec/plan cycle.
No oversizing. No wasted tokens.

## What changes

| Before | After |
|---|---|
| AI writes from scratch every time | AI searches, copies, adapts |
| Every session starts from zero | `CLAUDE.md` has full project state |
| Comments explain "what" | Comments are grep-friendly search indexes |
| Diffs are large and unpredictable | Diffs are small and traceable |
| Refactors things nobody asked for | Changes only what the task requires |
| Guesses API URLs from memory | Goes to official docs or asks |
| Context grows until it overflows | Clears after every commit |
| Needs conversation history for continuity | Code + CLAUDE.md = complete memory |

## Benchmark

*Coming soon — real data from daily usage.*

Metrics being tracked:
- Token consumption per task (with vs without)
- Diff size (files changed / lines)
- First-pass approval rate
- Cross-session recovery (rounds to resume)
- Code consistency across similar tasks

## Philosophy

Human code is maintainable not because humans are talented, but because
humans are weak enough to depend on frameworks, templates, and conventions —
battle-tested artifacts built by millions of developers over decades.

AI is dangerous precisely because it is strong enough to skip these crutches
and write everything from scratch. But "works" ≠ "maintainable." Code
written from scratch is an untested wheel.

**The fix: make AI weak like humans. Make it copy. Make it grep. Make it
reuse. Make it leave search indexes for its amnesiac next session.**

The person who will grep this codebase next week — with no context, no
memory, no idea why anything was written this way — is the next AI session.

Make sure what they find is worth copying.

---

*See you on the slopes.* ⛷️

## License

MIT
