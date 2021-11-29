#!/bin/bash

PID_FILE=/var/run/lpcb-volume.pid

case "$1" in
start)
  /userdata/system/lpcb-volume.py &
  echo $! > $PID_FILE
;;
stop)
  kill -9 `cat ${PID_FILE}`
  rm -f $PID_FILE
;;
esac
