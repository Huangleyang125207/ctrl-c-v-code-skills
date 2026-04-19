# Playbook: Scope

> Loaded by § 4.

## Rules

- Change only what the task requires. Nothing else
- Don't alter adjacent code, formatting, or naming
- Don't refactor working code outside task scope
- Don't implement TODOs/FIXMEs encountered during the task
- Unrelated issue → document separately, don't fix
- Every changed line traces to the task. If not → revert

## Stop signals

If any of these happen, pause and ask the human:
- Task requires 4+ files (might be LARGE, not MEDIUM)
- Shared function signature needs modification
- You're thinking "while I'm at it..."
- The diff needs a paragraph to describe
