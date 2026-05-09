# Playbook: TDD for LARGE tasks

> Loaded by § T6.

## The rhythm

```
Active spec → Test plan → All tests RED → Implement task by task
                                          (each task turns specific tests GREEN)
                                          → § 6 review → § 7 commit
```

## Active spec gets a Test plan section

Inside `## Active spec` in CLAUDE.md, after `### Plan`:

```
### Test plan
- [ ] T1 boundary: rejects [empty input, oversize, malformed]
- [ ] T2 contract: returns {id, status, created_at} on success
- [ ] T3 contract: raises ValidationError on bad input
- [ ] T4 effect: writes order row to orders table
- [ ] T5 effect: calls payment API exactly once with correct payload
- [ ] T6 effect: does NOT call payment API when validation fails
```

## Order of work

1. Write test plan in spec → human confirm
2. Write all tests in code, all RED, no implementation yet → commit:
   `test(scope): add failing tests for <feature>`
3. Break implementation into tasks. Each task: "make Tn turn GREEN"
4. Execute tasks one at a time:
   - Implement
   - Run test → confirm GREEN
   - § 6 self-review the diff
   - Commit: `feat(scope): <task>` with test name in body
5. After all tasks: full test run → all GREEN
6. Delete Active spec content per § 0 final cleanup

## Tasks checklist mapping

In CLAUDE.md `### Tasks`:

```
- [ ] T1: parse and validate input → verify: T1 + T2 + T3 GREEN
- [ ] T2: persist order to DB → verify: T4 GREEN
- [ ] T3: integrate payment API → verify: T5 + T6 GREEN
```

"Verify" means a specific test name, not a vague "it works."

## Anti-patterns specific to LARGE TDD

- Writing tests AFTER implementation. The whole point is RED first
- Writing all tests then disappearing for 3 hours. Commit RED tests first so the human sees the contract before implementation lands
- One giant test covering all categories. Split. Three failing tests are more diagnostic than one
- Skipping negative effect tests ("does NOT call X when Y"). Single most common LARGE bug source
