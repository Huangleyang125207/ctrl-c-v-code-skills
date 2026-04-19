#!/bin/bash
# setup.sh — Create all directories and starter files that CC expects.
# Run once after installing the plugin.

set -e

echo "Setting up Ctrl+C Ctrl+V Code Skills..."

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

# Playbooks directory (if manual install, copy from repo)
if [ ! -d ~/.claude/playbooks ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  if [ -d "$SCRIPT_DIR/playbooks" ]; then
    cp -r "$SCRIPT_DIR/playbooks" ~/.claude/playbooks
    echo "  ✓ Copied playbooks to ~/.claude/playbooks/"
  else
    mkdir -p ~/.claude/playbooks
    echo "  ✓ Created ~/.claude/playbooks/ (empty — populate from repo)"
  fi
else
  echo "  · ~/.claude/playbooks/ already exists"
fi

echo ""
echo "Done. To set up a project, copy the template:"
echo ""
echo "  cp ~/.claude/plugins/marketplaces/ctrl-c-v-code-skills/templates/CLAUDE_TEMPLATE.md ./CLAUDE.md"
echo ""
echo "Or if you installed manually:"
echo ""
echo "  cp <repo-path>/templates/CLAUDE_TEMPLATE.md ./CLAUDE.md"
echo ""
echo "See you on the slopes. ⛷️"
