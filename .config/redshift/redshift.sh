#!/bin/bash
PID=$(pgrep redshift-gtk)
echo $PID

if [ -z $PID ]; then
    redshift-gtk &
fi
