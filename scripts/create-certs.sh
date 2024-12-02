#!/bin/bash
set -eo pipefail

if [ ! -f config/certs/ca.zip ]; then
    echo "Creating CA" >&2
    bin/elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip
    unzip config/certs/ca.zip -d config/certs
fi
if [ ! -f config/certs/certs.zip ]; then
    echo "Creating certs" >&2
    echo -ne \
    "instances:\n"\
    "  - name: elasticsearch\n"\
    "    dns:\n"\
    "      - elasticsearch\n"\
    "      - kibana\n"\
    "      - localhost\n"\
    "    ip:\n"\
    "      - 127.0.0.1\n"\
    > config/certs/instances.yml
    bin/elasticsearch-certutil cert --silent --pem \
      -out config/certs/certs.zip --in config/certs/instances.yml \
      --ca-cert config/certs/ca/ca.crt --ca-key config/certs/ca/ca.key
    unzip config/certs/certs.zip -d config/certs
fi
chown -R root:root config/certs;
find . -type d -exec chmod 750 \{\} \;;
find . -type f -exec chmod 640 \{\} \;;
