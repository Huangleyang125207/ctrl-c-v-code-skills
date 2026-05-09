# Playbook: Writing tests from scratch

> Loaded by § T2 step 6. This should be rare.

## Before you start

Confirm steps 0–5 truly returned nothing.
If uncertain, ask: "No test pattern for [X]. Write from scratch?"

## Rules

- One test, one assertion focus. Don't bundle 8 unrelated asserts
- Test the boundary that matters — the § T3 categories. Not internals
- Mock external systems at the boundary. No real network, no real DB
- Test name reads as a sentence describing behavior, not method name
- If the test needs > 20 lines of setup, the code under test is wrong —
  flag it before continuing

## The tax

After the test passes RED → GREEN, before commit:

1. Add tags above the test:
   ```
   # TEST PATTERN: <category> — <variant>
   # USE WHEN: <one line: when this test shape applies>
   # COPY THIS: <one line: what to change when reusing>
   ```

2. Save a copy to `~/.claude/patterns/tests/<category>-<variant>.md`
   using the seed format (see templates/test-patterns-seed/).

3. Update `~/.claude/patterns/tests/INDEX.md`:
   ```
   | File | Category | Use when |
   |---|---|---|
   | <category>-<variant>.md | <category> | <conditions> |
   ```

This test is now a template. Next similar test = copy + change 5 lines.

## Save tax is not optional

Skipping the save tax = next session will write the same test from
scratch. The library only grows if you feed it. Every from-scratch
test that doesn't get saved is friction you owe your future self.
