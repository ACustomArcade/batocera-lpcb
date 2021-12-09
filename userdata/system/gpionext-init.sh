#!/bin/bash

PID_FILE=/var/run/gpionext.pid

case "$1" in
start)
  /usr/bin/python3 -u /userdata/system/GPIOnext/gpionext.py --debounce 1 --combo_delay 50 &> /var/log/gpionext &
  echo $! > $PID_FILE
;;
stop)
  kill -9 `cat ${PID_FILE}`
  rm -f $PID_FILE
;;
esac
