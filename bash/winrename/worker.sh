#!/bin/bash
set -e
source vars.sh

WID=${1}
shift

WIN_NAME=${*}

while true; do
  /usr/bin/xdotool set_window --name "${WIN_NAME}" "${WID}"

  /bin/sleep "${TICKER_PERIOD}"
done
