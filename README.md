# Elastic Stack Docker Compose

[Docker Compose](https://docs.docker.com/compose/) configuration to run the "ELK" stack components.

Runs:

* [Elasticsearch](https://www.elastic.co/elasticsearch)
* [The Elastic Distribution of OpenTelemetry Collector](https://github.com/elastic/opentelemetry)
* [Kibana](https://www.elastic.co/kibana)

### Requirements

* [Docker Compose](https://docs.docker.com/compose/)

### Usage

* Clone this repository
* `cd elastic-stack-docker-compose`
* `docker compose up`

#### Docker Comppose metrics

To collect [Docker Compose metrics](https://docs.docker.com/engine/cli/otel/), set the environment variable `DOCKER_CLI_OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317`. These metrics go to the `metrics-generic-default` data stream with `service.name=docker` and `service.name=docker-compose`.

## Data collected

* Any OpenTelemetry log, metric, or trace data sent to localhost:4317-4318 (use `host.docker.internal` from containers)
* [HTTP checks](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/httpcheckreceiver/README.md) for Elasticsearch and Kibana. These metrics go to the `metrics-generic-default` data stream with `http` and `httpcheck` fields.
* [Host metrics](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/hostmetricsreceiver). These are processed with the [Elastic Infra Metrics Processor](https://github.com/elastic/opentelemetry-collector-components/blob/main/processor/elasticinframetricsprocessor/README.md)

## Upstream docker-compose.yml configurations

This compose.yaml is based on these sources:

* [Elasticsearch](https://github.com/elastic/elasticsearch/blob/8b09e9119d17dcf82a67aaefdcd5ce224a5c8598/docs/reference/setup/install/docker/docker-compose.yml)
* [OpenTelemetry Demo](https://github.com/elastic/opentelemetry-demo/blob/main/docker-compose.yml)
