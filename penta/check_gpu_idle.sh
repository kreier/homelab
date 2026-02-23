#!/bin/bash

THRESHOLD=500        # MB
IDLE_TIME=600        # seconds
INTERVAL=10          # check interval

idle=0

while true; do
    used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -n1)

    if [ "$used" -lt "$THRESHOLD" ]; then
        idle=$((idle + INTERVAL))
    else
        idle=0
    fi

    if [ "$idle" -ge "$IDLE_TIME" ]; then
        echo "GPU idle → suspending"
        systemctl suspend
        exit
    fi

    sleep $INTERVAL
done
