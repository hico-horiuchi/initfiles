#!/bin/bash
# https://code.claude.com/docs/ja/statusline

input=$(cat)

IFS=$'\t' read -r MODEL WORKSPACE CONTEXT_WINDOW FIVE_HOUR_RATE SEVEN_DAY_RATE SESSION_ID < <(
    echo "${input}" | jq -r '[
        .model.display_name,
        .workspace.current_dir,
        (.context_window.used_percentage // 0),
        (.rate_limits.five_hour.used_percentage // ""),
        (.rate_limits.seven_day.used_percentage // ""),
        .session_id
    ] | @tsv'
)

CACHE_FILE="/tmp/statusline-git-cache-${SESSION_ID}"
CACHE_MAX_AGE=5

RESET='\033[0m'
RED='\033[31m';
GREEN='\033[32m';
YELLOW='\033[33m';

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

usage_bar() {
    local USAGE=${1%.*}
    local BAR_COLOR FILLED EMPTY FILL PAD BAR

    if [ "${USAGE}" -ge 90 ]; then
        BAR_COLOR="${RED}"
    elif [ "${USAGE}" -ge 70 ]; then
        BAR_COLOR="${YELLOW}"
    else
        BAR_COLOR="${GREEN}"
    fi

    FILLED=$((USAGE / 10))
    EMPTY=$((10 - FILLED))
    printf -v FILL "%${FILLED}s"
    printf -v PAD "%${EMPTY}s"

    BAR="${FILL// /█}${PAD// /░}"
    echo -e "${BAR_COLOR}${BAR}${RESET}"
}

INFO_LINE="🤖 ${MODEL} | 📁 ${WORKSPACE##*/}"
[ -n "${BRANCH}" ] && INFO_LINE="${INFO_LINE} | 🌿 ${BRANCH} +${STAGED} ~${MODIFIED}"
echo -e "${INFO_LINE}"

RATE_LINE="🧠 $(usage_bar "${CONTEXT_WINDOW}") ${CONTEXT_WINDOW%.*}%"
[ -n "${FIVE_HOUR_RATE}" ] && RATE_LINE="${RATE_LINE} | ⏱️ $(usage_bar "${FIVE_HOUR_RATE}") ${FIVE_HOUR_RATE%.*}%"
[ -n "${SEVEN_DAY_RATE}" ] && RATE_LINE="${RATE_LINE} | 📅 $(usage_bar "${SEVEN_DAY_RATE}") ${SEVEN_DAY_RATE%.*}%"
echo -e "${RATE_LINE}"
