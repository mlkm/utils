#!/bin/bash
set -e
cd "$(/usr/bin/dirname $(/bin/readlink -e "${0}"))"
source vars.sh

function run_bg {
  local NAME="${1}"
  shift

  local TARGET="$(/bin/readlink -e "${1}")"
  shift

  local MKTEMP_DIR="$(/bin/mktemp -d)"

  /bin/ln -sT "${TARGET}" "${MKTEMP_DIR}/${NAME}"

  /usr/bin/nohup "${MKTEMP_DIR}/${NAME}" "${@}" &>> "${TMP_DIR}/${NAME}.log" &
}

WIN_NAME_PREFIX="${*}"

if [[ -z "${WIN_NAME_PREFIX}" ]]; then
  /bin/echo >&2 "
Usage:
  ${0} WIN_NAME_PREFIX
"
  exit 1
fi

# Asks the user to click a window.
WID="$(/usr/bin/xdotool selectwindow)"

NAME="wnrnm${WID}"

/usr/bin/killall -- "${NAME}" &> /dev/null | true
run_bg "${NAME}" worker.sh "${WID}" "${WIN_NAME_PREFIX}"
