# Playbook: Aggregate

> Loaded by § H3, § H7.

## Why a separate index

The schedule file is chronological — events ordered by clock. The aggregation page is by topic — events grouped by project tag. Same data, two views. They must agree.

Why both? Because:
- JSONL = "when the user spoke" (after-the-fact forensic surface)
- Schedule = "when the event happened" (eyewitness writing)
- Aggregation = "what's happening on each project" (rolled-up view)

Three timelines, cross-checked, are more reliable than any one.

## Table format

```markdown
# Tag Aggregation

| Date | Time | Link | Content |
|------|------|------|---------|
| 5.7  | 9：30 | [26.5.7#9：30](daily/26.5.7.md#9：30) | ICP 备案后续 |
| 5.8  | 14：00 | [26.5.8#14：00](daily/26.5.8.md#14：00) | yanpai 域名迁移 dry run |
```

Columns:
- **Date**: short form `M.D` (or full `YYYY-MM-DD` per project convention)
- **Time**: must match the source H1 EXACTLY — full-width colon if source uses full-width
- **Link**: markdown link to `file#time-anchor`
- **Content**: one short phrase. Not a summary. The phrase should let user recall the entry without clicking.

## Write-back rules

```
□  One time-block = one row. Do NOT compress 3 entries on the same day into one row.
□  Append IMMEDIATELY when a project-tagged segment is added.
   Do not batch "I'll update the index at end-of-week" — index drift breaks recall.
□  Link uses `<filepath>#<exact-H1-text>` anchor syntax.
□  If the time format is full-width (`9：30`), the link anchor must also be full-width.
   Markdown anchors are case- and character-sensitive.
□  Sort order: chronological by (Date, Time) ascending.
```

## When to add a project tag to the aggregation

Triggers:
- New project-tagged paragraph appears in a daily log → add row
- Existing entry's tag changed → update existing row, do not duplicate
- Existing entry deleted from daily log → remove row from aggregation

## When NOT to add

- Generic tags (`#exercise`, `#leisure`, `#饮食`) do not get aggregated. Only project-named tags.
- `#协作` alone is not enough — must stack with a project tag.

## Dry-run check

After every aggregation update, eyeball:

```
□  Does row count match project-tagged paragraph count in the log?
□  Are time formats consistent within column (all full-width or all half-width)?
□  Does any row's link 404 if clicked?
```

If any answer is no, the aggregation has drifted. Fix before moving on.
