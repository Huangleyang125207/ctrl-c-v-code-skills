# Playbook: Self-review

> Loaded by § 6.

## Pre-commit checklist

```
□  Every changed line traces to the task
□  No accidental modifications to unrelated files
□  No hardcoded values that should reference constants
□  No new function that duplicates existing functionality
□  PATTERN tags added to any new reusable code
□  Names match existing project conventions
□  Comments explain WHY, not WHAT
□  Diff is approvable in 60 seconds
```

## Red flags

- File you didn't mean to touch → `git checkout -- <file>`
- Reformatted code you didn't write → revert those hunks
- New import for something the project already has → use existing
- Function > 40 lines → split before committing
