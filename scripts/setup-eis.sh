#!/bin/bash
set -eo pipefail

CA_CERT="/usr/share/elasticsearch/config/certs/ca/ca.crt"
ES_URL="https://elasticsearch:${ES_PORT}"
MAX_RETRIES=10
RETRY_INTERVAL=3

if [ -z "$EIS_API_KEY" ]; then
    echo "ERROR: EIS_API_KEY is not set." >&2
    echo "Get it from Vault: vault read secret/kibana-issues/dev/inference/kibana-eis-ccm" >&2
    exit 1
fi

for i in $(seq 1 $MAX_RETRIES); do
    echo "Attempt $i/$MAX_RETRIES: Configuring Cloud Connected Mode for EIS..." >&2

    HTTP_CODE=$(curl --no-progress-meter -w "%{http_code}" -o /tmp/eis_response.json \
        --cacert "$CA_CERT" \
        --user "elastic:${ELASTIC_PASSWORD}" \
        -H "Content-Type: application/json" \
        -X PUT \
        "${ES_URL}/_cluster/settings" \
        --data "{
            \"persistent\": {
                \"xpack.inference.elastic.cloud_connected_mode.api_key\": \"${EIS_API_KEY}\"
            }
        }" 2>/dev/null) || true

    if [ "$HTTP_CODE" = "200" ]; then
        echo "Cloud Connected Mode configured successfully for EIS." >&2
        exit 0
    fi

    echo "Attempt $i failed (HTTP $HTTP_CODE)" >&2

    if [ "$i" -eq "$MAX_RETRIES" ]; then
        echo "ERROR: Failed to configure CCM after $MAX_RETRIES attempts." >&2
        cat /tmp/eis_response.json >&2 2>/dev/null || true
        exit 1
    fi

    sleep $RETRY_INTERVAL
done
