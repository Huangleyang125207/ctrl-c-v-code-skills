# Playbook: Search

> Loaded by § 1 when you need search details.

## Search order (full detail)

```
0. ~/.claude/patterns/INDEX.md → scan table → match? → read that .md → copy
1. grep -r "PATTERN:" . → scan results → match? → copy from that file
2. Check framework docs: does the framework do this natively?
3. Check CLAUDE.md "Approved deps" → does a listed library do this?
4. Check templates/ or examples/ in this project → clone + fill
5. Search official website of the third-party service:
   - Find the docs page (not blog, not tutorial, not Stack Overflow)
   - Copy the example code verbatim
   - If docs are inaccessible, say so. Do not guess
6. Write from scratch. Then immediately:
   a. Add PATTERN/USE WHEN/COPY THIS tags to the code
   b. Save to ~/.claude/patterns/<type>-<variant>.md
   c. Update ~/.claude/patterns/INDEX.md
```

## Tag vocabulary (use these exact words)

```
Component types (fixed — do not invent new ones):
  card chart table form layout modal
  api db auth util config hook test

Format: # PATTERN: <type> — <variant in plain english>

Good:
  # PATTERN: chart — quantile band with company overlay
  # PATTERN: api — retry with exponential backoff

Bad:
  # PATTERN: 展示单指标与行业参考的对比
  # PATTERN: CustomMetricDisplayComponent
```

## grep techniques

```bash
grep -rn "PATTERN:" . --include="*.py" --include="*.ts" --include="*.md"
grep -rn "PATTERN: card" .
grep -l "PATTERN:.*api" ~/.claude/patterns/
grep -rn "decision:" . --include="*.py"
```

## When search fails

All steps return nothing → confirm with human before writing:
"No existing pattern for [X]. Writing from scratch and saving to patterns/. Proceed?"

Do not silently generate original code.
