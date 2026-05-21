#!/bin/bash
# https://code.claude.com/docs/ja/statusline

input=$(cat)

MODEL=$(echo "${input}" | jq -r '.model.display_name')
WORKSPACE=$(echo "${input}" | jq -r '.workspace.current_dir')
COST=$(echo "${input}" | jq -r '.cost.total_cost_usd // 0')
CONTEXT_WINDOW=$(echo "${input}" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "${input}" | jq -r '.cost.total_duration_ms // 0')
SESSION_ID=$(echo "$input" | jq -r '.session_id')

CACHE_FILE="/tmp/statusline-git-cache-${SESSION_ID}"
CACHE_MAX_AGE=5

RESET='\033[0m'
RED='\033[31m';
GREEN='\033[32m';
YELLOW='\033[33m';
CYAN='\033[36m';

cache_is_stale() {
    [ ! -f "${CACHE_FILE}" ] || \
    [ $(($(date +%s) - $(stat -f %m "${CACHE_FILE}" 2> /dev/null || echo 0))) -gt ${CACHE_MAX_AGE} ]
}

if cache_is_stale; then
    if git rev-parse --git-dir > /dev/null 2>&1; then
        BRANCH=$(git branch --show-current 2> /dev/null)
        STAGED=$(git diff --cached --numstat 2> /dev/null | wc -l | tr -d ' ')
        MODIFIED=$(git diff --numstat 2> /dev/null | wc -l | tr -d ' ')
        echo "${BRANCH}|${STAGED}|${MODIFIED}" > "${CACHE_FILE}"
    else
        echo '||' > "${CACHE_FILE}"
    fi
fi

IFS='|' read -r BRANCH STAGED MODIFIED < "${CACHE_FILE}"

if [ "${CONTEXT_WINDOW}" -ge 90 ]; then
    BAR_COLOR="${RED}"
elif [ "${CONTEXT_WINDOW}" -ge 70 ]; then
    BAR_COLOR="${YELLOW}"
else
    BAR_COLOR="${GREEN}"
fi

FILLED=$((CONTEXT_WINDOW / 10));
EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s";
printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

DURATION_MINS=$((DURATION_MS / 60000));
DURATION_SECS=$(((DURATION_MS % 60000) / 1000))

COST_FMT=$(printf '%.2f' "${COST}")

if [ -n "$BRANCH" ]; then
    echo -e "${CYAN}[$MODEL]${RESET} 📁 ${WORKSPACE##*/} | 🌿 ${BRANCH} +${STAGED} ~${MODIFIED}"
else
    echo -e "${CYAN}[$MODEL]${RESET} 📁 ${WORKSPACE##*/}"
fi
echo -e "${BAR_COLOR}${BAR}${RESET} ${CONTEXT_WINDOW}% | 💰 ${COST_FMT} | ⏱️ ${DURATION_MINS}m ${DURATION_SECS}s"
