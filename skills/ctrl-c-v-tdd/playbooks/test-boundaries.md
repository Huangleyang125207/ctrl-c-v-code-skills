# Playbook: Test boundaries

> Loaded by § T3.

## Three categories — each tests a different question

### Input boundary — does it reject bad input?

```
test "rejects empty input":
    expect error_type when fn("")
test "rejects null":
    expect error_type when fn(null)
test "rejects oversize":
    expect error_type when fn(string_of_length_max + 1)
test "rejects wrong type":
    expect error_type when fn(unexpected_type)
```

What "bad" means is domain-specific. List the inputs that should be
rejected before writing the tests. If the list is empty, the function
has no input boundary — skip this category.

### Contract — does it return what callers expect?

```
test "happy path returns expected shape":
    result = fn(valid_input)
    assert result.field_a == expected_a
    assert result.field_b == expected_b
test "returns specific error type on known failure":
    expect SpecificError when fn(known_failure_input)
```

Test the shape (field names, types, structure). Test the named error
types. Do not test internal state — only what callers see.

### Effect — does it produce the right side effect?

```
test "writes row to table on success":
    fn(input)
    assert db.query("...") returns expected_row
test "calls external API with correct payload":
    mock_api = mock()
    fn(input)
    assert mock_api.called_with(expected_payload)
test "does NOT call external on validation failure":
    mock_api = mock()
    expect error when fn(bad_input)
    assert mock_api.not_called
```

Always include the negative effect test ("does NOT call X when Y").
Forgetting this is the #1 cause of "we charged the customer twice"
incidents.

## What NOT to test

Private helpers (covered by § T0 table). Framework code (use it, don't test it). Trivial getters / setters. Logging output unless logs are a contract with another system.
