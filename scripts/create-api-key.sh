#!/bin/bash
set -eo pipefail

OUTPUT_FILE="/etc/elastic/api_key.yml"
CA_CERT="/usr/share/elasticsearch/config/certs/ca/ca.crt"
ES_URL="https://elasticsearch:${ES_PORT}"
MAX_RETRIES=30
RETRY_INTERVAL=2

# If an output file already exists, validate it has a non-empty api_key value
if [ -f "$OUTPUT_FILE" ]; then
    if grep -qE 'api_key: .+' "$OUTPUT_FILE"; then
        echo "API key already exists at $OUTPUT_FILE, skipping." >&2
        exit 0
    else
        echo "Found invalid API key file, regenerating..." >&2
        rm -f "$OUTPUT_FILE"
    fi
fi

# Retry loop — ES may not be fully ready for security API calls even when healthy
for i in $(seq 1 $MAX_RETRIES); do
    echo "Attempt $i/$MAX_RETRIES: Creating API key..." >&2

    RESPONSE=$(curl --no-progress-meter --fail -X POST \
        --cacert "$CA_CERT" \
        --user "elastic:${ELASTIC_PASSWORD}" \
        -H "Content-Type: application/json" \
        "${ES_URL}/_security/api_key" \
        --data @/etc/elastic/api_key_create_params.json 2>&1) && break

    echo "Attempt $i failed: $RESPONSE" >&2

    if [ "$i" -eq "$MAX_RETRIES" ]; then
        echo "ERROR: Failed to create API key after $MAX_RETRIES attempts." >&2
        exit 1
    fi

    sleep $RETRY_INTERVAL
done

# Validate the response contains an encoded key
API_KEY=$(echo "$RESPONSE" | jq --raw-output '.encoded // empty')

if [ -z "$API_KEY" ]; then
    echo "ERROR: API response did not contain an encoded key." >&2
    echo "Response was: $RESPONSE" >&2
    exit 1
fi

# Write the output file only after validation
cat > "$OUTPUT_FILE" <<EOF
exporters:
  elasticsearch/otel:
    api_key: ${API_KEY}
EOF

echo "API key successfully created and written to $OUTPUT_FILE" >&2
