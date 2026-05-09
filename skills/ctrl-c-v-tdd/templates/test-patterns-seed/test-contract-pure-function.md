# TEST PATTERN: contract — pure function, happy + 2 errors
# USE WHEN: input → output mapping, no side effects, deterministic
# COPY THIS: change function name, fixture, expected output, error types
# TESTED IN: ctrl-c-v-tdd seed (2026-05)

## Shape (language-agnostic)

```
test "happy path returns expected output":
    result = fn(valid_input)
    assert result == expected_output

test "returns expected error type for known failure A":
    expect SpecificErrorA when fn(failure_input_A)

test "returns expected error type for known failure B":
    expect SpecificErrorB when fn(failure_input_B)
```

## Python + pytest

```python
import pytest
from mymod import calculate_discount, InvalidTier, NegativeAmount

def test_calculate_discount_happy():
    assert calculate_discount(amount=100, tier="gold") == 20

def test_calculate_discount_unknown_tier():
    with pytest.raises(InvalidTier):
        calculate_discount(amount=100, tier="platinum")

def test_calculate_discount_negative_amount():
    with pytest.raises(NegativeAmount):
        calculate_discount(amount=-1, tier="gold")
```
