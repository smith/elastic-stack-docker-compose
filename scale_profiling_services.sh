#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <scale_number>"
    exit 1
fi

scale_number=$1
services=("setup_universal_profiling" "profiling-collector" "linux-vm" "profiling-agent")

for service in "${services[@]}"; do
    echo "Scaling $service to $scale_number..."
    docker compose scale "$service=$scale_number"
done

echo "All profiling services scaled to $scale_number successfully!"