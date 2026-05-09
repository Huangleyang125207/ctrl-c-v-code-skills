# TEST PATTERN: boundary — input validation
# USE WHEN: function accepts external input that has explicit "valid" rules
# COPY THIS: change function name, replace each invalid_input case with your domain values
# TESTED IN: ctrl-c-v-tdd seed (2026-05)

## Shape (language-agnostic)

```
test "rejects empty input":
    expect ValidationError when fn("")

test "rejects null":
    expect ValidationError when fn(null)

test "rejects oversize":
    expect ValidationError when fn(string_at_max_length + 1)

test "rejects wrong type":
    expect ValidationError when fn(unexpected_type_value)

test "rejects malformed":
    expect ValidationError when fn(domain_specific_malformed_value)

test "accepts known-good":
    expect no error when fn(valid_canonical_input)
```

## Python + pytest

```python
import pytest
from mymod import validate_email

@pytest.mark.parametrize("bad", ["", None, "x" * 1000, 123, "no-at-sign"])
def test_validate_email_rejects(bad):
    with pytest.raises(ValueError):
        validate_email(bad)

def test_validate_email_accepts():
    assert validate_email("user@example.com") == "user@example.com"
```
