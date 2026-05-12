#!/bin/bash
# schedule-self-audit.sh — Stop hook
#
# Runs after every AI turn. If a 半小时复盘/ MD file was modified in the last
# 5 minutes, emits a system-reminder reminding the AI to self-audit its
# just-written entries against the "1-year test": will future-you, glancing
# at this entry 12 months from now, still know what happened that day?
#
# Why this exists: § H5 says "result + significance" but in practice AI keeps
# slipping into procedure dump — version numbers, file paths, tool names,
# library names — all of which decay to noise in months. The 1-year test is
# a sharper rubric than "result + significance" because it's a concrete
# question with a yes/no answer.

set -e

# — gate: only run in projects with a schedule directory —
has_schedule_dir() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    for c in "$dir/数据库/valut/半小时复盘" "$dir/journal" "$dir/schedule"; do
      [ -d "$c" ] && echo "$c" && return 0
    done
    dir=$(dirname "$dir")
  done
  return 1
}

SCHEDULE_DIR=$(has_schedule_dir) || exit 0

# — detect recent edit —
RECENT=$(find "$SCHEDULE_DIR" -name "*.md" -type f -newermt "-5 minutes" 2>/dev/null | head -1)
[ -z "$RECENT" ] && exit 0

# — emit audit reminder —
cat <<EOF
[schedule-audit] 检测到刚写了 schedule。下一轮回应前对刚写的 entry 自审：

  □  1 年后只看这条 entry 5 秒，记得当天大致干了啥吗？
  □  有版本号 (v0.4 / v0.4.1)、工具名 (FastAPI / DeepSeek)、文件路径、API 名、库名？删
  □  有数字 (15s / 200 行 / 3 个 tool) 但这数字不是记忆点？删
  □  #commit 行：保留风险 + 未来 TODO；删纯实现状态说明 ("没真测过"等)
  □  最终每个 entry 散文 ≤ 3 句，title 句不算

任一不及格 → 下次回应**先改 schedule 再答用户问题**，不许借口"用户问别的"跳过。
EOF

exit 0
