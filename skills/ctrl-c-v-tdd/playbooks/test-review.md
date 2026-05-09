# Playbook: Test self-review

> Loaded by § T5.

## Pre-commit checklist

```
□  Test name reads as a sentence: "rejects_empty_email"
   Not method name: "test_validate_email_1"

□  One test, one assertion focus
   Multiple asserts OK if they verify ONE behavior

□  No test depends on another's order
   Run any test alone → passes. Run in random order → passes

□  No real network, no real DB, no real filesystem
   Mock the boundary. Test framework provides test doubles

□  Test fails for the right reason
   Comment out the implementation → does the test go RED?
   If still GREEN → test is testing nothing

□  TEST PATTERN tag added if shape is reusable
   Pattern: # TEST PATTERN: <category> — <variant>

□  Test file mirrors source per framework convention
   foo.py ↔ test_foo.py | foo.ts ↔ foo.test.ts | foo.go ↔ foo_test.go

□  No commented-out tests in the diff
   Either delete or fix. Commented = future confusion
```

## Red flags

- Test still GREEN when impl deleted → test is wrong, rewrite
- Test only fails on Tuesdays → flakiness, fix or delete
- Setup block longer than the test → simplify or refactor code under test
- Test name contains "and" → split into multiple tests
- Mock has 10+ lines of configuration → boundary is too wide, narrow it
- Two tests fail together when one is broken → shared state, isolate

## Coverage is not the goal

Boundary coverage > line coverage. A function with 100% line coverage
and no boundary tests is undertested. A function with 60% line
coverage and tests for every § T3 category is well-tested.

Stop chasing the coverage number. Start asking § T0's questions.
