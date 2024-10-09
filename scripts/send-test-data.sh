#!/bin/bash
curl -X POST \
    --insecure http://localhost:4318/v1/logs \
    -H "Content-Type: application/json" \
    --data "@$(dirname "$0")/../test/log.json"
curl -X POST \
    --insecure http://localhost:4318/v1/traces \
    -H "Content-Type: application/json" \
    --data "@$(dirname "$0")/../test/span.json"
