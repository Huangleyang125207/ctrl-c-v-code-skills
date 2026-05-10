# ctrl-c-v

> **Coding doctrine.** Makes AI search before generating, copy before
> writing, distill comments into a search index. Activates on every
> task that creates / modifies / refactors code in any language.

The base skill in this bundle. Tdd extends it; schedule references
its `§ 0` initialization hook. If you only install one, install this.

## When this activates

- User asks to write / add / fix / implement code
- Request mentions a function / class / module / endpoint / script
- File changes touch any source extension (`.py .ts .tsx .js .go .rb
  .rs .java .kt .swift .cpp .c .cs .php .lua .sh ...`)
- User shares an error and asks to fix
- User asks for code review of a diff or PR
- User opens a project for the first time (no `CLAUDE.md` present)

## When it doesn't

- Pure markdown / config edit (`.yaml .json .toml .env`)
- Conceptual question without code-change intent ("how does X work")
- Diary / journal / retro / supplement notes
- Pure prompt / spec / doc authoring
- Reading code only (no edit intended)
- Deleting files as a side effect of a non-code task

## Sections in SKILL.md

Read [`skills/ctrl-c-v/SKILL.md`](../skills/ctrl-c-v/SKILL.md) for full
detail. Each section is short with a `@playbook/` pointer for depth:

| § | What | Playbook |
|---|------|----------|
| 0 | Project initialization | — |
| 1 | Find before you write (search hierarchy) | `search.md` |
| 2 | Copy, don't rewrite | `copy.md` |
| 3 | Tag everything for search (PATTERN / decision) | `index.md` |
| 4 | Touch only what the task requires (scope) | `scope.md` |
| 5 | Write from scratch (rare; pays the indexing tax) | `scratch.md` |
| 6 | Self-review before commit | `review.md` |
| 7 | Commit and deliver (`type(scope): what`) | `commit.md` |
| 8 | Collaboration norms | `collab.md` |

## Examples

**Triggers**:

```
"implement a login endpoint that issues JWTs"
"fix this NullPointerException in payment.rs"
"refactor the parser into 3 smaller functions"
"add a useEffect hook to sync localStorage"
```

**Skips**:

```
"explain what async/await actually does in Python"
"今天的复盘：上午跟设计师讨论了 ICP 备案"
"write a README for this project"
"delete those old screenshot files"
```

## Anti-patterns

| Doing this | Do this instead |
|---|---|
| Writing from scratch first | Search `~/.claude/patterns/` + project grep first |
| "Inspired" rewrite of existing code | Copy structure exactly, change only content |
| Improving code outside the current task | Separate task. Separate commit |
| Touching 5 files for 1 feature | One file at a time: copy, adapt, verify |
| Hardcoded `"#1B3A5B"` magic value | Named constant from a config module |
| Variable named `data` / `tmp` / `result` | Domain-specific name |
| Comment that says "calculate X" | Comment that says WHY this approach |
| Implementing a TODO you found | Not your task. Document, don't act |

## Files in this skill

```
skills/ctrl-c-v/
├── SKILL.md
└── playbooks/
    ├── search.md
    ├── copy.md
    ├── index.md
    ├── scope.md
    ├── scratch.md
    ├── review.md
    ├── commit.md
    └── collab.md
```

Templates referenced by `§ 0`: `templates/CLAUDE_TEMPLATE.md`,
`templates/PULSE_TEMPLATE.md`.
