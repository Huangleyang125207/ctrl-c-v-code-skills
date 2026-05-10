# ctrl-c-v-tdd

> **Test-pattern doctrine.** Tests are copyable from
> `~/.claude/patterns/tests/`, three categories: input boundary,
> contract, effect. Activates on code that touches a boundary where
> someone else's code meets yours.

Extension on top of `ctrl-c-v` (declares `extends: ctrl-c-v`). Same
narrative engineer, same Friday flight — but this skill exists because
the code that gets you called back on Saturday is the code you forgot
to test at the boundary.

## When this activates

- Code under change has external callers (other modules, cron, CLI,
  HTTP/RPC clients, "外部调用")
- Code persists state (DB write, file write, redis/cache, session
  storage, anything that survives the request)
- Code calls a third-party API/SDK
- Task is classified as LARGE per ctrl-c-v sizing (4+ files, new
  capability, new architecture, new external contract)
  — **LARGE always triggers TDD regardless of caller scope**
- User mentions: tests, TDD, 测试, boundary, contract, mock, fixture,
  red/green
- Business domain involves: payments, queues, webhooks, auth,
  external integration

## When it doesn't

- Code change is purely internal helpers used only by the caller in
  the same file
- Pure UI rendering with no validation/state
- Accessor < 10 lines with no if/loop/exception
- One-file fix that ctrl-c-v classifies as SMALL

## Sections in SKILL.md

Read [`skills/ctrl-c-v-tdd/SKILL.md`](../skills/ctrl-c-v-tdd/SKILL.md):

| § | What | Playbook |
|---|------|----------|
| T0 | When TDD activates (caller-based decision table) | — |
| T1 | TDD integrates with ctrl-c-v task sizing | — |
| T2 | Find before you write (test version) | `test-search.md` |
| T3 | Test the boundary, not the implementation | `test-boundaries.md` |
| T4 | Tests are also patterns (`# TEST PATTERN:` tags) | `test-copy.md` |
| T5 | Test self-review | `test-review.md` |
| T6 | LARGE tasks: spec drives tests drives code | `test-large.md` |

## Examples

**Triggers**:

```
"implement a Stripe webhook handler that marks the order paid"
"add retry to the upload pipeline"
"this database migration"
"build a multi-step checkout form with validation across steps"
```

**Skips**:

```
"rename this private function"
"fix formatting in style.css"
```

## Three test categories

```
boundary  — function rejects bad external input
            (test-boundary-input-validation.md seed)
contract  — pure input → output, or stateful object across methods
            (test-contract-pure-function.md / test-contract-stateful-class.md)
effect    — code calls third-party HTTP / writes DB
            (test-effect-external-api-mock.md / test-effect-database-transaction.md)
```

5 seed patterns ship at `templates/test-patterns-seed/` and are
deployed by `setup.sh` into `~/.claude/patterns/tests/`.

## Anti-patterns

| Doing this | Do this instead |
|---|---|
| Skipping tests because "it's just internal" | Re-check § T0 caller table |
| Writing tests for impl details (private fns) | Test the boundary contract |
| Mocking your own internal code | Only mock the third-party boundary |
| Writing tests AFTER coding | RED first; tests precede impl on LARGE |
| Three tests of the same kind | One per category (boundary/contract/effect) |
| New test from scratch | Search `~/.claude/patterns/tests/INDEX.md` first |

## Post-commit hook

`scripts/post-commit-tdd-check.sh` ships with this skill. After install
(via `setup.sh` + manual hook registration in `~/.claude/settings.json`),
the hook fires when CC commits via `Bash(git commit*)`:

- Warns if commit touches `src/` but not `tests/`
- Warns if `# TEST PATTERN:` tag added but no new file in
  `~/.claude/patterns/tests/`

Silent unless one of those conditions hits.

## Files in this skill

```
skills/ctrl-c-v-tdd/
├── SKILL.md
└── playbooks/
    ├── test-search.md
    ├── test-copy.md
    ├── test-boundaries.md
    ├── test-scratch.md
    ├── test-review.md
    └── test-large.md
```

Templates: `templates/CLAUDE_TDD_PATCH.md` (project CLAUDE.md patches),
`templates/test-patterns-seed/*.md` (5 starter test patterns).
