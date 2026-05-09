# TEST PATTERN: effect — database transaction
# USE WHEN: code persists to DB; use real test DB or transactional rollback
# COPY THIS: change table, fields, transaction boundary, error case
# TESTED IN: ctrl-c-v-tdd seed (2026-05)

## Shape (language-agnostic)

```
test "writes row on success":
    fn(input, db=test_db)
    rows = test_db.query("SELECT * FROM table WHERE ...")
    assert len(rows) == 1
    assert rows[0].field == expected_value

test "rolls back on error":
    initial_count = test_db.count("table")
    expect DomainError when fn(input_that_partially_fails, db=test_db)
    assert test_db.count("table") == initial_count

test "is idempotent on retry":
    fn(input, db=test_db)
    fn(input, db=test_db)   # same input, second call
    assert test_db.count("table WHERE ...") == 1   # not 2
```

## Python + pytest + sqlalchemy

```python
import pytest
from mymod import create_order, DuplicateOrder

def test_writes_order_row(db_session):
    create_order(user_id="u1", amount=100, db=db_session)
    rows = db_session.execute("SELECT * FROM orders WHERE user_id='u1'").all()
    assert len(rows) == 1
    assert rows[0].amount == 100

def test_rolls_back_on_payment_failure(db_session, mocker):
    mocker.patch("mymod.charge_card", side_effect=PaymentError)
    initial = db_session.scalar("SELECT count(*) FROM orders")
    with pytest.raises(PaymentError):
        create_order(user_id="u1", amount=100, db=db_session)
    final = db_session.scalar("SELECT count(*) FROM orders")
    assert final == initial   # no half-written order

def test_idempotent_on_duplicate_request(db_session):
    create_order(user_id="u1", amount=100, idempotency_key="k1", db=db_session)
    create_order(user_id="u1", amount=100, idempotency_key="k1", db=db_session)
    assert db_session.scalar("SELECT count(*) FROM orders WHERE idempotency_key='k1'") == 1
```
