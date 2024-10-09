#!/bin/bash
set -eo pipefail

if [ -z "$ELASTIC_PASSWORD" ]; then
    echo "Set the ELASTIC_PASSWORD environment variable in the .env file" >&2;
    exit 1;
elif [ -z "$KIBANA_PASSWORD" ]; then
    echo "Set the KIBANA_PASSWORD environment variable in the .env file" >&2;
    exit 1;
fi;
curl --no-progress-meter -X POST \
    --cacert config/certs/ca/ca.crt \
    --cert config/certs/elasticsearch/elasticsearch.crt \
    --cert config/certs/elasticsearch/elasticsearch.key \
    --user "elastic:$ELASTIC_PASSWORD" \
    -H "Content-Type: application/json" \
    https://elasticsearch:$ES_PORT/_security/user/kibana_system/_password \
    --data "{\"password\":\"$KIBANA_PASSWORD\"}"
