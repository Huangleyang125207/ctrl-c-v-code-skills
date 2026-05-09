# CLAUDE.md TDD Patch

Apply on top of an existing CLAUDE.md from CLAUDE_TEMPLATE.md.
Three insertions plus an Active spec extension.

---

## Insertion 1 — extend References table

Append to `## References`:

```
| Test patterns / TDD playbooks | @~/.claude/patterns/tests/INDEX.md |
| Test framework conventions | @docs/test-conventions.md |
```

## Insertion 2 — extend Project rules

Append to `## Project rules (always active)`:

```
- Test framework: [pytest / vitest / go test / rspec / ...] — set once, never mix
- Test file location: [tests/ alongside src/ | __tests__/ | _test.go]
- Mocking strategy: [pytest-mock / vi.mock / gomock / built-in / ...]
```

## Insertion 3 — modify size protocols

### SMALL — step 3

Replace `3. Self-review diff` with:
```
3. Self-review diff (§ 6) — § T0 confirms NO tests for SMALL
```

### MEDIUM — step 2

Replace `2. grep nearest pattern → copy → adapt → verify` with:
```
2. § T0 → external caller exists?
   YES: grep TEST PATTERN → copy test → RED →
        grep code pattern → copy → adapt → GREEN
   NO:  grep code pattern → copy → adapt → verify (§ 6 only)
```

### LARGE — Step 2 and Step 5

Step 2: append `(INCLUDING ### Test plan subsection per § T6)` to
"Write spec in Active spec below".

Step 5: prepend "Write all tests RED first, commit them. Then" before
"Execute one task at a time:". Inside the per-task loop, add
`run targeted tests → confirm GREEN` between "Do the task" and
"commit".

## Active spec — extension (LARGE only)

After `### Plan`, add:

```
### Test plan
- [ ] T1 boundary: rejects [bad inputs]
- [ ] T2 contract: returns [shape] when [condition]
- [ ] T3 effect: writes [row] / calls [api] on success
- [ ] T4 effect: does NOT call [external] when [condition]
```

Tasks `verify:` references test names:
```
- [ ] T1: [task] → verify: T1 + T2 GREEN
```

---

## Apply

Manual: paste each block at marked location.
Scripted: `bash setup.sh --patch-claude` appends Insertion 1 and 2
(size protocols are manual — they depend on existing wording).
