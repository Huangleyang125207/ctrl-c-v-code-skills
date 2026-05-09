# TEST PATTERN: effect — external API mock with retry
# USE WHEN: code calls third-party HTTP / RPC / SDK; you own the caller side
# COPY THIS: change API client, payload shape, retry config, error class
# TESTED IN: ctrl-c-v-tdd seed (2026-05)

## Shape (language-agnostic)

```
test "calls API once on success":
    mock_api = mock()
    mock_api.returns(success_response)
    fn(input)
    assert mock_api.call_count == 1
    assert mock_api.called_with(expected_payload)

test "retries on transient failure":
    mock_api = mock()
    mock_api.returns_sequence([fail, fail, success])
    fn(input)
    assert mock_api.call_count == 3

test "does NOT call API on local validation failure":
    mock_api = mock()
    expect ValidationError when fn(invalid_input)
    assert mock_api.call_count == 0
```

## Python + pytest + pytest-mock

```python
import pytest
from mymod import send_payment, APIError

def test_calls_api_once_on_success(mocker):
    api = mocker.patch("mymod.payment_api.charge", return_value={"id": "p1"})
    send_payment(amount=100, user_id="u1")
    api.assert_called_once_with(amount=100, user_id="u1")

def test_retries_on_transient(mocker):
    api = mocker.patch("mymod.payment_api.charge",
                       side_effect=[TimeoutError, TimeoutError, {"id": "p1"}])
    send_payment(amount=100, user_id="u1")
    assert api.call_count == 3

def test_does_not_call_api_on_validation_failure(mocker):
    api = mocker.patch("mymod.payment_api.charge")
    with pytest.raises(ValueError):
        send_payment(amount=-1, user_id="u1")
    api.assert_not_called()
```
