# Playbook: JSONL Forensics

> Loaded by § H6.

## Default JSONL location

Claude Code stores per-session logs under:

```
~/.claude/projects/<slug>/<session-uuid>.jsonl
```

`<slug>` is the cwd path with non-alphanumeric chars replaced by `-`. Example:

```
/Users/me/myproject  →  -Users-me-myproject
```

To discover sessions for the current project:

```bash
ls -lt ~/.claude/projects/ | head -10
ls -lt ~/.claude/projects/<slug>/*.jsonl | head -5
```

## The retrieval flow (5 steps)

```
1. List session logs by mtime → identify candidates near day X
2. Filter by absolute date in timestamp (NEVER by file mtime)
3. Extract user + agent messages with timestamps
4. Surface to user → confirm content matches their memory
5. Write into dated file ONLY after confirmation
```

### Step 1 — List candidates

```bash
ls -lt ~/.claude/projects/<slug>/*.jsonl | head -10
```

mtime tells you when the session was last touched. **Don't use it to infer what date events fall on** — a session can span multiple days.

### Step 2 — Filter by timestamp date

```bash
jq -r 'select(.type=="user" and (.timestamp | startswith("2026-05-08"))) | "\(.timestamp)  \(.message.content)"' \
  <session>.jsonl
```

Replace `2026-05-08` with the target date. This filters by ACTUAL message-sent time.

### Step 3 — Extract user + assistant messages

For full retrospective ("what did we discuss"), you need both sides:

```bash
jq -r 'select(.type=="user" or .type=="assistant") | "[\(.timestamp)] [\(.type)] \(.message.content | if type=="string" then . else (map(select(.type=="text") | .text) | join(" ")) end | gsub("\n"; " ") | .[0:200])"' \
  <session>.jsonl \
  | grep -v "system-reminder\|ide_opened\|ide_selection" \
  | grep -vE "^\[\S+\] \[\S+\]\s*$" \
  | grep "^\[2026-05-08"
```

The grep filters drop noise: system reminders, IDE selections, empty lines.

### Step 4 — Surface and confirm

Show the user the filtered output. Ask: "Is this what you mean by 'X day'?" Wait for confirmation. Common mistakes when skipping this step:
- Day X had two sessions; you grabbed the wrong one
- User actually meant "the conversation that started on X" not "every message timestamped X"
- User remembered a different topic

### Step 5 — Write only after confirmation

Once user confirms, place the recovered content into the appropriate dated file's appropriate time-block per § H1 locate logic. Do not write before confirmation.

## Red lines

- **NEVER use file mtime** to infer event date. mtime = last write time, often unrelated to event date.
- **Assistant messages are also dated.** When reconstructing decisions ("how did we decide on X"), include `assistant` messages alongside `user`. Otherwise you see the question without the answer.
- **Always surface raw output before writing.** Two-step confirmation is cheap; misplaced reconstruction is invisibly wrong.

## Common path discovery commands

```bash
# Project slug for current cwd
echo $PWD | sed 's|/|-|g'

# All sessions for a project
ls ~/.claude/projects/-Users-me-myproject/*.jsonl

# Most recent message across all projects
find ~/.claude/projects/ -name '*.jsonl' -mtime -1 -exec ls -lt {} +
```
