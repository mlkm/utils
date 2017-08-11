#!/bin/bash
set -e
cd "$(/usr/bin/dirname $(/bin/readlink -e "${0}"))"
source vars.sh

function run_bg {
  local NAME=${1}
  shift

  local TARGET=$(/bin/readlink -e "${1}")
  shift

  local MKTEMP_DIR=$(/bin/mktemp -d)

  /bin/ln -sT "${TARGET}" "${MKTEMP_DIR}/${NAME}"

  /usr/bin/nohup "${MKTEMP_DIR}/${NAME}" "${@}" &>> "${TMP_DIR}/${NAME}.log" &
}

# Asks the user to click a window.
WID=$(/usr/bin/xdotool selectwindow)

NAME="wnrnm${WID}"
WIN_NAME=${*}

/usr/bin/killall -- "${NAME}" &> /dev/null | true
if [[ -n "${WIN_NAME}" ]]; then
  run_bg "${NAME}" worker.sh "${WID}" "${WIN_NAME}"
else
  /bin/echo >&2 "
Usage:
  ${0} WIN_NAME
"
  exit 1
fi
