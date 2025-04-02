# Elastic Stack Docker Compose
[![OpenTelemetry collector configuration on OTelBin](https://www.otelbin.io/badges/collector-config)](https://www.otelbin.io/s/f508f8ba981f3e209723054e71d6bcfef478ed70)

[Docker Compose](https://docs.docker.com/compose/) configuration to run the [Elastic Stack](https://www.elastic.co/elastic-stack/) components.

This is meant to be a development and demo environment to solve these problems:

- Work on development of OpenTelemetry-related features in Elastic Observability
- Run pre-release builds of components to preview upcoming features
- Get an Elastic environment that can collect OpenTelemetry data up and running quickly

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
* Open https://localhost:5601
* Log in with `elastic`/`changeme`
* Adjust configuration in the files in this repository for your needs
* If you have improvements or fixes, open a pull request to https://github.com/smith/elastic-stack-docker-compose

#### OpenTelemetry Demo

To send data from the [OpenTelemetry Demo](https://opentelemetry.io/ecosystem/demo/) to this cluster, check out a copy of the demo, and update [src/otel-collector/otelcol-config-extras.yml](https://github.com/open-telemetry/opentelemetry-demo/blob/main/src/otel-collector/otelcol-config-extras.yml]):

```yaml
exporters:
  otlp:
    endpoint: "http://host.docker.internal:4317"

service:
  pipelines:
    metrics:
      exporters: [otlp, debug]
    logs:
      exporters: [otlp, debug]
```

`docker compose up` to start the demo. It will send all data from the demo's collector over OTLP to ours.

#### Kibana TLS

Kibana is configured for HTTP2 by default. The HTTPS connection will not be trusted unless you configure your operating system to trust the certificate.

To get a copy out of the certificate from a running environment run:

```bash
docker compose run setup_certs cat config/certs/elasticsearch/elasticsearch.crt > cert
```

On MacOS you can add this certificate to the trusted store with:

```bash
sudo security add-trusted-cert -d -r trustAsRoot -p ssl -k /Library/Keychains/System.keychain cert
```

You'll need to do this again if the volume for the certificates gets recreated.

#### Docker Compose metrics

To collect [Docker Compose metrics](https://docs.docker.com/engine/cli/otel/), set the environment variable `DOCKER_CLI_OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317`. These metrics go to the `metrics-generic-default` data stream with `service.name=docker` and `service.name=docker-compose`.

#### Selecting which services to run

If you don't need a particular service (let's say you already have Kibana running in dev mode), you can add `scale: 0` to the service definition to prevent it from being started when `docker compose up` is run. You can also run `docker compose stop SERVICE_NAME` to stop an individual service.

#### Elastic APM Server

[Elastic APM Server](https://www.elastic.co/guide/en/observability/current/apm-getting-started-apm-server.html#apm-setup-apm-server-binary) is included for testing with legacy scenarios.

By default the `apmserver` section in [compose.yml](./compose.yaml) contains `scale: 0`. Increase this number in the compose.yaml or run `docker compose scale apmserver=1`.

To configure the OpenTelemetry collector to send data to the APM Server, uncomment the `traces/fromsdk` pipeline under the `# Send traces to APM server` comment.

#### Updating image

In [.env](./env) the default image variables look like this:

```
KIBANA_IMAGE=docker.elastic.co/kibana/kibana:9.0.0-SNAPSHOT
```

When you first start, it will download the latest snapshot image. to update to the latest image, for, for example, Kibana, run:

```bash
docker compose stop kibana
docker compose rm -f kibana
compose pull kibana
```

You can omit `kibana` to update all images.

## Data collected

* Any OpenTelemetry log or metric data sent to localhost:4317-4318 (use `host.docker.internal` from containers.)
* [HTTP checks](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/httpcheckreceiver/README.md) for Elasticsearch and Kibana. These metrics go to the `metrics-generic-default` data stream with `http` and `httpcheck` fields.
* [Host metrics](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/hostmetricsreceiver). These are processed with the [Elastic Infra Metrics Processor](https://github.com/elastic/opentelemetry-collector-components/blob/main/processor/elasticinframetricsprocessor/README.md)
* [OpenTelemetry collector internal logs, metrics and traces](https://opentelemetry.io/docs/collector/internal-telemetry/)
* Logs from Elasticsearch and Kibana

## Upstream docker-compose.yml configurations

This compose.yaml is based on these sources:

* [Elasticsearch](https://github.com/elastic/elasticsearch/blob/8b09e9119d17dcf82a67aaefdcd5ce224a5c8598/docs/reference/setup/install/docker/docker-compose.yml)
* [OpenTelemetry Demo](https://github.com/elastic/opentelemetry-demo/blob/main/docker-compose.yml)

## Why doesn't this use Kubernetes?

If you need Kubernetes, you should use it. See the [Elastic Kubernetes documentation](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-elasticsearch.html). This is a simpler environment meant to run on a single computer.
