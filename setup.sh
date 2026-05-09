#!/bin/bash
# setup.sh — Create all directories and starter files that CC expects.
# Run once after installing the plugin. Idempotent — safe to re-run.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up Ctrl+C Ctrl+V Code Skills..."

# --- Base skill (ctrl-c-v) -----------------------------------------------

# Cross-project patterns library
mkdir -p ~/.claude/patterns
if [ ! -f ~/.claude/patterns/INDEX.md ]; then
  cat > ~/.claude/patterns/INDEX.md << 'EOF'
# Pattern Index

| File | Type | Use when |
|---|---|---|
EOF
  echo "  ✓ Created ~/.claude/patterns/INDEX.md"
else
  echo "  · ~/.claude/patterns/INDEX.md already exists"
fi

# Playbooks travel with the skill (skills/ctrl-c-v/playbooks/).
# No separate copy needed — SKILL.md references them via ${CLAUDE_SKILL_DIR}/playbooks/.

# --- TDD sub-skill (ctrl-c-v-tdd) ----------------------------------------

echo ""
echo "Setting up TDD sub-skill..."

# Tests pattern subdirectory
mkdir -p ~/.claude/patterns/tests
if [ ! -f ~/.claude/patterns/tests/INDEX.md ]; then
  cat > ~/.claude/patterns/tests/INDEX.md << 'EOF'
# Test Pattern Index

| File | Category | Use when |
|---|---|---|
EOF
  echo "  ✓ Created ~/.claude/patterns/tests/INDEX.md"
else
  echo "  · ~/.claude/patterns/tests/INDEX.md already exists"
fi

# Seed test patterns (only if patterns/tests/ is empty besides INDEX)
SEED_DIR="$SCRIPT_DIR/skills/ctrl-c-v-tdd/templates/test-patterns-seed"
SEED_COUNT=$(ls -1 ~/.claude/patterns/tests/ 2>/dev/null | grep -v "^INDEX.md$" | wc -l)
if [ "$SEED_COUNT" -eq 0 ] && [ -d "$SEED_DIR" ]; then
  cp "$SEED_DIR"/*.md ~/.claude/patterns/tests/
  cat >> ~/.claude/patterns/tests/INDEX.md << 'EOF'
| test-boundary-input-validation.md | boundary | function rejects bad external input |
| test-contract-pure-function.md | contract | pure input → output, no side effects |
| test-contract-stateful-class.md | contract | object holds state across method calls |
| test-effect-external-api-mock.md | effect | code calls third-party HTTP / RPC |
| test-effect-database-transaction.md | effect | code persists to DB |
EOF
  echo "  ✓ Seeded ~/.claude/patterns/tests/ with 5 starter patterns"
else
  echo "  · ~/.claude/patterns/tests/ already populated, skipping seed"
fi

# Install TDD post-commit hook script (silent unless TDD signals present)
mkdir -p ~/.claude/scripts
HOOK_SRC="$SCRIPT_DIR/skills/ctrl-c-v-tdd/scripts/post-commit-tdd-check.sh"
if [ -f "$HOOK_SRC" ]; then
  cp "$HOOK_SRC" ~/.claude/scripts/
  chmod +x ~/.claude/scripts/post-commit-tdd-check.sh
  echo "  ✓ Installed ~/.claude/scripts/post-commit-tdd-check.sh"
fi

# Hook registration in settings.json — manual only (we don't touch user config)
SETTINGS=~/.claude/settings.json
TDD_CMD="bash ~/.claude/scripts/post-commit-tdd-check.sh"

if [ ! -f "$SETTINGS" ]; then
  cat > "$SETTINGS" << EOF
{"hooks":{"PostToolUse":[{"matcher":"Bash(git commit*)","hooks":[{"type":"command","command":"$TDD_CMD"}]}]}}
EOF
  echo "  ✓ Created $SETTINGS with TDD post-commit hook"
elif grep -q "post-commit-tdd-check" "$SETTINGS" 2>/dev/null; then
  echo "  · TDD post-commit hook already in $SETTINGS"
else
  echo ""
  echo "  ⚠️  $SETTINGS exists but lacks the TDD hook."
  echo "      Add this manually to .hooks.PostToolUse[]:"
  echo ""
  echo "      {\"matcher\": \"Bash(git commit*)\","
  echo "       \"hooks\": [{\"type\": \"command\", \"command\": \"$TDD_CMD\"}]}"
fi

# --- Final notes ---------------------------------------------------------

echo ""
echo "Done. To set up a project, copy the template:"
echo ""
echo "  cp ~/.claude/plugins/marketplaces/ctrl-c-v-code-skills/templates/CLAUDE_TEMPLATE.md ./CLAUDE.md"
echo ""
echo "Or if you installed manually:"
echo ""
echo "  cp <repo-path>/templates/CLAUDE_TEMPLATE.md ./CLAUDE.md"
echo ""
echo "For TDD-extended projects, also see templates/CLAUDE_TDD_PATCH.md"
echo ""
echo "See you on the slopes. ⛷️"
