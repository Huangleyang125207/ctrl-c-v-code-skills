# Playbook: Copy

> Loaded by § 2.

## Method

`cp existing.py new.py` → change domain-specific content → done.

- Same function signatures, same naming, same error handling
- Change only: data, labels, keys, business logic
- Preserve structure, patterns, style, quirks

## Anti-patterns

| Wrong | Right |
|---|---|
| Read it, understand it, rewrite "better" | Copy structure exactly |
| Use as "inspiration" | Duplicate, then modify content |
| Copy idea, change architecture | Keep architecture identical |
| "Improve" original while copying | Copy faithfully. Improvement = separate task |

## Quirk preservation

Weird variable name or unusual pattern = scar from a fixed bug.
Before "fixing" it, check git blame. Deviate = reintroduce the bug.
