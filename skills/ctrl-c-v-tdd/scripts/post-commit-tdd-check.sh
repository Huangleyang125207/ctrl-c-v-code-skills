#!/bin/bash
# post-commit-tdd-check.sh
# Runs after git commit. Silent unless TDD signals are present.
# Two checks:
#   1. src changed but tests/ untouched
#   2. # TEST PATTERN: added in code but ~/.claude/patterns/tests/ unchanged
# Both checks output questions, not orders. User decides.

# Existence gate — if user has not opted into TDD mode library, stay silent
[ ! -d ~/.claude/patterns/tests ] && exit 0
PATTERN_COUNT=$(ls -1 ~/.claude/patterns/tests/ 2>/dev/null | grep -v "^INDEX.md$" | wc -l)
[ "$PATTERN_COUNT" -eq 0 ] && exit 0

# Need a previous commit to diff against
git rev-parse HEAD~1 >/dev/null 2>&1 || exit 0

CHANGED=$(git diff HEAD~1 HEAD --name-only 2>/dev/null)
[ -z "$CHANGED" ] && exit 0

# --- Check 1: src changed, tests/ untouched ---
SRC_CHANGED=$(echo "$CHANGED" | grep -E '\.(py|ts|tsx|js|jsx|go|rb|rs|java|kt|swift)$' | grep -vE '(^|/)(tests?|__tests__|spec)/' || true)
TEST_CHANGED=$(echo "$CHANGED" | grep -E '(^|/)(tests?|__tests__|spec)/' || true)

if [ -n "$SRC_CHANGED" ] && [ -z "$TEST_CHANGED" ]; then
  # Filter: ignore docs/config-only changes
  REAL_SRC=$(echo "$SRC_CHANGED" | grep -vE '\.(md|json|yaml|yml|toml|cfg|ini)$' || true)
  if [ -n "$REAL_SRC" ]; then
    echo "⚠️  TDD: this commit touched src but not tests/."
    echo "   § T0 caller table — was this an internal helper or pure UI?"
    echo "   If yes, ignore. If no, the test boundary may be missing."
  fi
fi

# --- Check 2: TEST PATTERN tag added but patterns/tests/ unchanged ---
NEW_TAG=$(git diff HEAD~1 HEAD -U0 2>/dev/null | grep -E '^\+.*TEST PATTERN:' || true)
if [ -n "$NEW_TAG" ]; then
  PATTERNS_DIR_EXPANDED="$HOME/.claude/patterns/tests"
  # Did this commit also touch patterns/tests/? (only relevant if repo IS patterns dir,
  # but most commits are not — so this check is about save-tax in the AGENT'S session,
  # which we approximate by checking if patterns/tests/ has been written to recently)
  RECENT_PATTERN=$(find "$PATTERNS_DIR_EXPANDED" -name "*.md" -newer "$PATTERNS_DIR_EXPANDED/INDEX.md" -mmin -30 2>/dev/null | head -1)
  if [ -z "$RECENT_PATTERN" ]; then
    echo "⚠️  TDD: code added a # TEST PATTERN: tag,"
    echo "   but ~/.claude/patterns/tests/ has no new file in the last 30 min."
    echo "   § T2 step 6 save tax: did you forget to save the pattern?"
  fi
fi

exit 0
