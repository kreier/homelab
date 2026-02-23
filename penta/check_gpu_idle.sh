#!/bin/bash

GPU_MEM_THRESHOLD=500     # MB
CPU_THRESHOLD=10          # % average CPU considered "active"
NET_THRESHOLD=1024        # bytes/sec considered activity
IDLE_TIME=600             # seconds before suspend
INTERVAL=10

idle=0

get_gpu_used() {
    nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | awk '{sum+=$1} END{print sum}'
}

get_cpu_usage() {
    top -bn1 | awk '/Cpu\(s\)/ {print 100-$8}'
}

get_net_bytes() {
    cat /proc/net/dev | awk 'NR>2 {rx+=$2; tx+=$10} END{print rx+tx}'
}

has_ssh_sessions() {
    who | grep -qE 'pts|tty'
}

last_net=$(get_net_bytes)

while true; do
    gpu=$(get_gpu_used)
    cpu=$(get_cpu_usage)
    net_now=$(get_net_bytes)
    net_diff=$((net_now - last_net))
    last_net=$net_now

    if has_ssh_sessions; then
        echo "Active SSH session detected → not idle"
        idle=0

    elif (( $(echo "$gpu > $GPU_MEM_THRESHOLD" | bc -l) )); then
        echo "GPU active ($gpu MB)"
        idle=0

    elif (( $(echo "$cpu > $CPU_THRESHOLD" | bc -l) )); then
        echo "CPU active ($cpu %)"
        idle=0

    elif [ "$net_diff" -gt "$NET_THRESHOLD" ]; then
        echo "Network active ($net_diff bytes)"
        idle=0

    else
        idle=$((idle + INTERVAL))
        echo "Idle for $idle sec"
    fi

    if [ "$idle" -ge "$IDLE_TIME" ]; then
        echo "System idle → suspending"
        systemctl suspend
        exit
    fi

    sleep $INTERVAL
done
