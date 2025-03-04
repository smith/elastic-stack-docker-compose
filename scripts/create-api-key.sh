#!/bin/bash
set -eo pipefail
# TODO: This can fail and give you a YAML file where the key is empty
test -f /etc/elastic/api_key.yml || \
curl --no-progress-meter --fail -X POST \
    --cacert /usr/share/elasticsearch/config/certs/ca/ca.crt \
    --user "elastic:$ELASTIC_PASSWORD" \
    -H "Content-Type: application/json" \
    "https://elasticsearch:$ES_PORT/_security/api_key" \
    --data @/etc/elastic/api_key_create_params.json | \
jq --raw-output .encoded | \
(
cat <<EOF
exporters:
  elasticsearch/ecs: &api_key
    api_key: $(cat)
  elasticsearch/otel: *api_key
EOF
) > /etc/elastic/api_key.yml
