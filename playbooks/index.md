# Playbook: Index

> Loaded by § 3 when you need indexing details.

## In-code tags (mandatory on every reusable function)

```python
# PATTERN: <type> — <variant>
# USE WHEN: <one line: conditions for reuse>
# COPY THIS: <one line: what to change when duplicating>
def function_name(clear, obvious, params):
    ...

# decision: <why this approach over alternatives>
# revisit if: <conditions that would change this choice>
```

## Naming rules

- Functions: `verb_noun` — `render_kpi_card`, `fetch_stock_metrics`
- Files: `noun.py` — `kpi_card.py`, `quantile_trend.py`
- Constants: `UPPER_SNAKE` — `COLORS`, `FONTS`, `API_BASE_URL`
- Never: `v2`, `new_`, `tmp_`, `data`, `result`, `handle`, `process`

Test: can you find this by guessing its name? If not, rename it.

## ~/.claude/patterns/ file format

One pattern per file. Filename: `<type>-<variant>.md`

```markdown
# PATTERN: api — retry with exponential backoff
# USE WHEN: calling any external API that may fail transiently
# COPY THIS: change base_url, max_retries, timeout
# TESTED IN: quant-dashboard (2026-04)

\```python
def api_call_with_retry(url, payload, max_retries=3, timeout=30):
    ...
\```
```

## INDEX.md maintenance

Location: `~/.claude/patterns/INDEX.md`

```markdown
| File | Type | Use when |
|---|---|---|
| card-kpi.md | card | single metric vs benchmark |
| chart-quantile-band.md | chart | time series with percentile bands |
| api-retry-backoff.md | api | external call needs retry |
```

Update INDEX.md every time you add or modify a pattern file.
