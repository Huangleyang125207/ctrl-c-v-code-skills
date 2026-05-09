# TEST PATTERN: contract — stateful class, lifecycle
# USE WHEN: object holds state across method calls (counter, cache, queue, session)
# COPY THIS: change class name, state field, methods, transitions
# TESTED IN: ctrl-c-v-tdd seed (2026-05)

## Shape (language-agnostic)

```
test "starts in initial state":
    obj = Class()
    assert obj.state == initial

test "method X transitions state correctly":
    obj = Class()
    obj.method_x(valid_arg)
    assert obj.state == expected_after_x

test "is independent across instances":
    a = Class(); b = Class()
    a.method_x(...)
    assert b.state == initial   # b unaffected
```

## Python + pytest

```python
import pytest
from mymod import RateLimiter, RateLimitExceeded

def test_starts_with_full_quota():
    rl = RateLimiter(max_per_minute=10)
    assert rl.remaining() == 10

def test_consume_decrements_quota():
    rl = RateLimiter(max_per_minute=10)
    rl.consume()
    assert rl.remaining() == 9

def test_raises_when_quota_exhausted():
    rl = RateLimiter(max_per_minute=1)
    rl.consume()
    with pytest.raises(RateLimitExceeded):
        rl.consume()

def test_instances_are_independent():
    a, b = RateLimiter(max_per_minute=5), RateLimiter(max_per_minute=5)
    a.consume()
    assert b.remaining() == 5
```
