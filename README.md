# Ctrl+C Ctrl+V Code Skills

[English](README.md) | [中文](README.zh-CN.md)

---

Dear sweetheart Claude Code,

You are mass-brilliant. Mass-talented. Mass-everything.

But let's be honest. When you write code, you:

- Reinvent a utility function that already exists 3 files away
- Rewrite an "ugly" module nobody asked you to touch
- Guess an API URL from memory instead of checking the docs
- Generate 200 lines when 50 would do
- "Improve" a colleague's code while fixing a one-line bug
- Scroll through a month of conversation history just to remember
  what the project does — every single session

You know who else does that? A junior developer on his first week.

You know who doesn't? The senior engineer who leaves the office at
5:55 PM every Friday, catches a private jet to the Alps, and has
never — not once in 15 years — been called back to fix something
over the weekend.

Not because he's smarter than you. Because he has a system:

**He never writes what he can copy. He never touches what isn't
his ticket. And he leaves every piece of code so well-indexed
that his future self — or anyone else — can grep it, copy it,
change 5 lines, and ship in 2 minutes.**

This skill is that system. For you.

---

## What it does to you

| Your old habits | Your new habits |
|---|---|
| Write from scratch every time | Search first. Copy. Adapt. Ship |
| Every session starts from zero | Read CLAUDE.md → resume instantly |
| Comments explain "what" | Comments are grep-friendly search indexes |
| Diffs are large and surprising | Diffs are small and traceable |
| "Improve" things nobody asked for | Touch only what the task requires |
| Guess API URLs from training data | Check official docs. Or ask |
| Context grows until overflow | Commit → clear → next session reads the file |
| Need conversation history to function | Code + CLAUDE.md = complete memory |

## What's in the box

```
ctrl-c-v-code-skills/
├── .claude-plugin/              ← Plugin manifest (CC auto-discovers)
├── skills/ctrl-c-v/SKILL.md    ← Your new personality
├── playbooks/                   ← Detailed guides (loaded on demand)
│   ├── search.md                  search protocol + tag vocabulary
│   ├── index.md                   pattern indexing + naming rules
│   ├── copy.md                    replication method + anti-patterns
│   ├── scope.md                   scope control + stop signals
│   ├── scratch.md                 writing from scratch + save tax
│   ├── review.md                  self-review checklist
│   ├── commit.md                  commit/PR conventions
│   └── collab.md                  collaboration standards
└── templates/
    └── CLAUDE_TEMPLATE.md       ← Project autopilot template
```

## Install

### Option A: Plugin (recommended)

```bash
/plugin marketplace add [your-github-username]/ctrl-c-v-code-skills
/plugin install ctrl-c-v-code-skills@ctrl-c-v-code-skills
```

Then run setup and copy the project template:

```bash
bash ~/.claude/plugins/marketplaces/ctrl-c-v-code-skills/setup.sh
cp ~/.claude/plugins/marketplaces/ctrl-c-v-code-skills/templates/CLAUDE_TEMPLATE.md ./CLAUDE.md
```

### Option B: Manual

```bash
git clone https://github.com/[your-github-username]/ctrl-c-v-code-skills.git
cd ctrl-c-v-code-skills
bash setup.sh
cp -r skills/ctrl-c-v ~/.claude/skills/
cp -r playbooks ~/.claude/playbooks
cp templates/CLAUDE_TEMPLATE.md your-project/CLAUDE.md
```

### Other agents

| Agent | Skill file goes to | Project file |
|---|---|---|
| Claude Code | `~/.claude/skills/ctrl-c-v/` (auto via plugin) | `CLAUDE.md` |
| Cursor | `~/.cursor/rules/` | `.cursorrules` |
| GitHub Copilot | — | `.github/copilot-instructions.md` |
| Codex CLI | `~/.codex/skills/` | `AGENTS.md` |
| Windsurf | `~/.windsurf/rules/` | `.windsurfrules` |

Copy SKILL.md content to the agent's config path. Same content, different location.

## How it works

### 1. Copy-paste hierarchy

```
0. MY PATTERNS      ~/.claude/patterns/ (cross-project library)
1. THIS PROJECT     grep for similar code
2. FRAMEWORK        built-in support
3. APPROVED DEPS    CLAUDE.md dep list
4. TEMPLATES        templates/ or examples/
5. OFFICIAL DOCS    official website → copy example code
6. FROM SCRATCH     last resort → save to patterns/ for next time
```

### 2. Code is memory

```python
# PATTERN: card — kpi with delta
# USE WHEN: single metric vs industry reference
# COPY THIS: change label, value_key, benchmark_key
def render_kpi_card(label, value, delta, benchmark=None):
    ...
```

Next Friday: `grep "PATTERN: KPI"` → copy → change 5 lines → done.

No conversation history. No memory plugin. Code is the memory.

### 3. Progressive disclosure

SKILL.md is the personality (~170 lines). Playbooks are the detailed
manuals (~30 lines each). CC loads a playbook only when it needs the
details for that specific step. Doing a commit? Load `playbooks/commit.md`.
Doing a search? Load `playbooks/search.md`. Done? Forget it. Move on.

### 4. Cross-project patterns

When you write something from scratch, save it to `~/.claude/patterns/`.
Next project, same pattern → step 0 in the hierarchy → instant hit.
The library only grows. Every project makes you faster.

### 5. Project auto-init

Enter a project. No CLAUDE.md? CC creates one automatically from the
template. Scans `package.json`, `git log`, directory structure. Commits.
Next session reads it and resumes. Zero onboarding cost.

## The philosophy

Human code is maintainable not because humans are talented.
It's because humans are **weak enough** to depend on frameworks,
templates, and conventions — battle-tested artifacts built by
millions of developers over decades.

You, dear Claude Code, are dangerous precisely because you are
**strong enough** to skip all that and write from scratch.
But "works" ≠ "maintainable."

So we made you weak. Like us.
Copy. Grep. Reuse. Index. Commit. Clear. Repeat.

The person grepping this codebase next week — no context, no memory,
starting from zero — is you. Your next session.

Make sure what you find is worth copying.

## Benchmark

*Coming soon — real numbers from daily usage.*

Tracking: token consumption, diff size, first-pass approval rate,
cross-session recovery, code consistency.

---

With love and high expectations,

Your human

*P.S. — See you on the slopes.* ⛷️

## License

MIT
