#!/bin/bash
set -eo pipefail

MARKER_FILE="/etc/elastic/saved_objects_imported"
KIBANA_URL="https://kibana:${KIBANA_PORT}"
CA_CERT="/usr/share/elasticsearch/config/certs/ca/ca.crt"
MAX_RETRIES=30
RETRY_INTERVAL=5

if [ -f "$MARKER_FILE" ]; then
    echo "Saved objects already imported, skipping." >&2
    exit 0
fi

for i in $(seq 1 $MAX_RETRIES); do
    echo "Attempt $i/$MAX_RETRIES: Importing saved objects..." >&2

    HTTP_CODE=$(curl --no-progress-meter -w "%{http_code}" -o /tmp/import_response.json \
        --cacert "$CA_CERT" \
        --user "elastic:${ELASTIC_PASSWORD}" \
        -H "kbn-xsrf: true" \
        -F file=@/etc/elastic/kibana-saved-objects.ndjson \
        "${KIBANA_URL}/api/saved_objects/_import?overwrite=true" 2>/dev/null) || true

    if [ "$HTTP_CODE" = "200" ]; then
        echo "Saved objects imported successfully." >&2
        touch "$MARKER_FILE"
        exit 0
    fi

    echo "Attempt $i failed (HTTP $HTTP_CODE)" >&2

    if [ "$i" -eq "$MAX_RETRIES" ]; then
        echo "ERROR: Failed to import saved objects after $MAX_RETRIES attempts." >&2
        cat /tmp/import_response.json >&2 2>/dev/null || true
        exit 1
    fi

    sleep $RETRY_INTERVAL
done
