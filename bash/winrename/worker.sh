#!/bin/bash
set -e
source vars.sh

WID="${1}"
shift

WIN_NAME_PREFIX="[${*}] "

while true; do
  WIN_NAME="$(/usr/bin/xdotool getwindowname "${WID}")"

  # Strip all occurences of WIN_NAME_PREFIX from the beginning of WIN_NAME.
  while [[ "${WIN_NAME}" == "${WIN_NAME_PREFIX}"* ]]; do
    WIN_NAME="${WIN_NAME:${#WIN_NAME_PREFIX}}"
  done

  # Prepend WIN_NAME_PREFIX to WIN_NAME.
  WIN_NAME="${WIN_NAME_PREFIX}${WIN_NAME}"

  /usr/bin/xdotool set_window --name "${WIN_NAME}" "${WID}"

  /bin/sleep "${TICKER_PERIOD}"
done
