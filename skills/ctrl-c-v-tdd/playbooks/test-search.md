# Playbook: Test search

> Loaded by § T2.

## Search order (full detail)

```
0. ~/.claude/patterns/tests/INDEX.md → scan table → match? → read .md → copy
1. grep -rn "TEST PATTERN:" tests/ → match? → copy from that file
2. Test framework: built-in fixture / parametrize / mock?
3. CLAUDE.md "Approved deps" → test helper / mock library listed?
4. tests/templates/ or example test files → clone + fill
5. Test framework's official docs:
   - Find docs page (not blog, not Stack Overflow)
   - Copy example verbatim
   - If docs are inaccessible, say so. Do not guess
6. Write from scratch. Then immediately:
   a. Add TEST PATTERN / USE WHEN / COPY THIS tags
   b. Save to ~/.claude/patterns/tests/<category>-<variant>.md
   c. Update ~/.claude/patterns/tests/INDEX.md
```

## Tag vocabulary (use these exact words)

```
Categories (fixed — do not invent new ones):
  boundary contract effect

Format: # TEST PATTERN: <category> — <variant in plain english>

Good:
  # TEST PATTERN: boundary — input validation rejects empty / null
  # TEST PATTERN: contract — pure function happy + 2 errors
  # TEST PATTERN: effect — external API mock with retry

Bad:
  # TEST PATTERN: 测试 API 拒绝空输入
  # TEST PATTERN: MyCustomTestThatChecksStuff
```

## grep techniques

```bash
grep -rn "TEST PATTERN:" tests/
grep -rn "TEST PATTERN: contract" .
grep -l "TEST PATTERN:.*effect" ~/.claude/patterns/tests/
grep -rn "decision:" tests/  # decisions made about what NOT to test
```

## When search fails

All steps return nothing → confirm with human before writing:
"No existing test pattern for [X]. Writing from scratch and saving to
patterns/tests/. Proceed?"

Do not silently generate original test code.
