#!/bin/bash
# https://code.claude.com/docs/ja/statusline

input=$(cat)

IFS=$'\t' read -r MODEL EFFORT WORKSPACE SESSION_ID CONTEXT_WINDOW COST DURATION_MS FIVE_HOUR_RATE FIVE_HOUR_RESET SEVEN_DAY_RATE SEVEN_DAY_RESET < <(
    echo "${input}" | jq -r '
        def secs_left: if . == null then "" else (. - now | floor) end;
        [
            .model.display_name,
            .effort.level,
            .workspace.current_dir,
            .session_id,
            (.context_window.used_percentage // 0),
            (.cost.total_cost_usd // 0),
            (.cost.total_duration_ms // 0),
            (.rate_limits.five_hour.used_percentage // ""),
            (.rate_limits.five_hour.resets_at | secs_left),
            (.rate_limits.seven_day.used_percentage // ""),
            (.rate_limits.seven_day.resets_at | secs_left)
        ] | @tsv
    '
)

CACHE_FILE="/tmp/statusline-git-cache-${SESSION_ID}"
CACHE_MAX_AGE=5

RESET='\033[0m';
BOLD='\033[1m';
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

remaining_time() {
    local LEFT=${1}
    local UNIT=${2}

    [ -n "${LEFT}" ] || return
    [ "${LEFT}" -lt 0 ] && LEFT=0

    if [ "${UNIT}" = 'dh' ]; then
        printf '%dd%dh' $((LEFT / 86400)) $(((LEFT % 86400) / 3600))
    else
        printf '%dh%dm' $((LEFT / 3600)) $(((LEFT % 3600) / 60))
    fi
}

INFO_LINE="🤖 ${MODEL} ${BOLD}${EFFORT}${RESET} | 📁 ${WORKSPACE##*/}"
[ -n "${BRANCH}" ] && INFO_LINE="${INFO_LINE} | 🌿 ${BRANCH} +${STAGED} ~${MODIFIED}"
echo -e "${INFO_LINE}"

USAGE_LINE="🧠 $(usage_bar "${CONTEXT_WINDOW}") ${CONTEXT_WINDOW%.*}%"
if [ "${CLAUDE_CODE_STATUSLINE_MODE}" = 'cost' ]; then
    COST_FMT=$(printf '$%.2f' "${COST}")
    DURATION_MINS=$((DURATION_MS / 60000))
    DURATION_SECS=$(((DURATION_MS % 60000) / 1000))
    USAGE_LINE="${USAGE_LINE} | 💰 ${COST_FMT} | ⏱️ ${DURATION_MINS}m ${DURATION_SECS}s"
else
    FIVE_HOUR_LEFT=$(remaining_time "${FIVE_HOUR_RESET}" 'hm')
    SEVEN_DAY_LEFT=$(remaining_time "${SEVEN_DAY_RESET}" 'dh')
    [ -n "${FIVE_HOUR_RATE}" ] && USAGE_LINE="${USAGE_LINE} | ⏱️ $(usage_bar "${FIVE_HOUR_RATE}") ${FIVE_HOUR_RATE%.*}%${FIVE_HOUR_LEFT:+ ${BOLD}(${FIVE_HOUR_LEFT})${RESET}}"
    [ -n "${SEVEN_DAY_RATE}" ] && USAGE_LINE="${USAGE_LINE} | 📅 $(usage_bar "${SEVEN_DAY_RATE}") ${SEVEN_DAY_RATE%.*}%${SEVEN_DAY_LEFT:+ ${BOLD}(${SEVEN_DAY_LEFT})${RESET}}"
fi
echo -e "${USAGE_LINE}"
