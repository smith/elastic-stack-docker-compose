#!/bin/bash
set -eo pipefail
if [ -z "$ELASTIC_PASSWORD" ]; then
    echo "Set the ELASTIC_PASSWORD environment variable in the .env file" >&2;
    exit 1;
fi;
curl --no-progress-meter --fail -X POST \
    --cacert /usr/share/elasticsearch/config/certs/ca/ca.crt \
    --user "elastic:$ELASTIC_PASSWORD" \
    -H "Content-Type: application/json" \
    -H "kbn-xsrf: true" \
    https://kibana:$KIBANA_PORT/internal/profiling/setup/es_resources
