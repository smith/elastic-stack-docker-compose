# Elastic Stack Docker Compose
[![OpenTelemetry collector configuration on OTelBin](https://www.otelbin.io/badges/collector-config)](https://www.otelbin.io/s/c5777df93e729bf37c83bb48928714b67e8bb42c)

[Docker Compose](https://docs.docker.com/compose/) configuration to run the [Elastic Stack](https://www.elastic.co/elastic-stack/) components.

This is meant to be a development and demo environment to solve these problems:

- Work on development of OpenTelemetry-related features in Elastic Observability
- Run pre-release builds of components to preview upcoming features
- Get an Elastic environment that can collect OpenTelemetry data up and running quickly

Runs:

* [Elastic APM server](https://www.elastic.co/guide/en/observability/current/apm-getting-started-apm-server.html) _(this is temporary until the Elastic OpenTelemetry collector can do the processing that is done by APM server. This work is in progress.)_
* [Elasticsearch](https://www.elastic.co/elasticsearch)
* [The Elastic Distribution of OpenTelemetry Collector](https://github.com/elastic/opentelemetry)
* [Kibana](https://www.elastic.co/kibana)

### Requirements

* [Docker Compose](https://docs.docker.com/compose/)

### Usage

* Clone this repository
* `cd elastic-stack-docker-compose`
* `docker compose up`
* Open http://localhost:5601
* Log in with `elastic`/`changeme`
* Adjust configuration in the files in this repository for your needs
* If you have improvements or fixes, open a pull request to https://github.com/smith/elastic-stack-docker-compose

#### Docker Comppose metrics

To collect [Docker Compose metrics](https://docs.docker.com/engine/cli/otel/), set the environment variable `DOCKER_CLI_OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317`. These metrics go to the `metrics-generic-default` data stream with `service.name=docker` and `service.name=docker-compose`.

#### Selecting which services to run

If you don't need a particular service (let's say you already have Kibana running in dev mode), you can add `scale: 0` to the service definition to prevent it from being started when `docker compose up` is run. You can also run `docker compose stop SERVICE_NAME` to stop an individual service.

## Data collected

* Any OpenTelemetry log or metric data sent to localhost:4317-4318 (use `host.docker.internal` from containers)
* Any trace data is sent to the APM server
* [HTTP checks](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/httpcheckreceiver/README.md) for Elasticsearch and Kibana. These metrics go to the `metrics-generic-default` data stream with `http` and `httpcheck` fields.
* [Host metrics](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/hostmetricsreceiver). These are processed with the [Elastic Infra Metrics Processor](https://github.com/elastic/opentelemetry-collector-components/blob/main/processor/elasticinframetricsprocessor/README.md)

## Upstream docker-compose.yml configurations

This compose.yaml is based on these sources:

* [Elasticsearch](https://github.com/elastic/elasticsearch/blob/8b09e9119d17dcf82a67aaefdcd5ce224a5c8598/docs/reference/setup/install/docker/docker-compose.yml)
* [OpenTelemetry Demo](https://github.com/elastic/opentelemetry-demo/blob/main/docker-compose.yml)

## Why doesn't this use Kubernetes?

If you need Kubernetes, you should use it. See the [Elastic Kubernetes documentation](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-elasticsearch.html). This is a simpler environment meant to run on a single computer.
