# Playbook: Test copy

> Loaded by § T4 when copying a test pattern.

## Method

`cp pattern.md test_new.<ext>` → strip the pattern header → change
fixture / assertion / function name → done.

- Same test structure, same setup/teardown, same naming convention
- Change only: function under test, fixtures, expected values, error types
- Preserve: assertion style, mock setup, test isolation pattern

## Anti-patterns

| Wrong | Right |
|---|---|
| Read pattern, write "cleaner" version | Copy structure exactly |
| Use as inspiration for a new approach | Duplicate, then modify content |
| Keep pattern's framework but change style | Keep both. Style is the pattern |
| Skip the setup block "because it looks unused" | Copy it. It is there for a reason |

## Quirk preservation

Weird mock setup or unusual teardown = scar from a flaky test that
was finally fixed. Before "simplifying" it, check git blame on the
original. Deviate = reintroduce the flakiness.

## Multi-language adaptation

Test patterns in `~/.claude/patterns/tests/` are written in one
language. Copying across languages: keep the SHAPE (categories,
order of assertions, mock semantics). Translate only the syntax.

```
Pattern (python+pytest)        →    Adapted (typescript+vitest)
def test_rejects_empty():           it("rejects empty", () => {
    with pytest.raises(ValueError):     expect(() => fn("")).toThrow(ValueError)
        fn("")                       })
```

Same shape, different syntax. The shape is what you copied.
