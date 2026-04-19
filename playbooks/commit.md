# Playbook: Commit and deliver

> Loaded by § 7.

## Format

`type(scope): what changed` — one line, one concern, full story.

Types: `feat fix style refactor docs test chore`

```
feat(stepper): add 5-step horizontal agent workflow
fix(chart): render company curve on quantile trend plot
style(kpi): left-align metric values per design.md §6.1
refactor(nodes): extract shared key-value table component
chore(deps): pin akshare to 1.12.3 for Q3 compat
```

## Rules

- One commit = one concern. If it does two things, split it
- PR: focused diff, commits tell the story, no side-effects
- The standard: approved while you are unreachable
