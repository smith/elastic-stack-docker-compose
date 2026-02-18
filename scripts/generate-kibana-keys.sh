#!/bin/bash
set -eo pipefail

OUTPUT_FILE="/etc/elastic/kibana_encryption_keys.yml"

if [ -f "$OUTPUT_FILE" ]; then
    echo "Kibana encryption keys already exist at $OUTPUT_FILE, skipping." >&2
    exit 0
fi

# Generate three 32-character hex keys
KEY1=$(dd if=/dev/urandom bs=16 count=1 2>/dev/null | xxd -p)
KEY2=$(dd if=/dev/urandom bs=16 count=1 2>/dev/null | xxd -p)
KEY3=$(dd if=/dev/urandom bs=16 count=1 2>/dev/null | xxd -p)

cat > "$OUTPUT_FILE" <<EOF
xpack.encryptedSavedObjects.encryptionKey: ${KEY1}
xpack.reporting.encryptionKey: ${KEY2}
xpack.security.encryptionKey: ${KEY3}
EOF

echo "Kibana encryption keys generated and written to $OUTPUT_FILE" >&2
