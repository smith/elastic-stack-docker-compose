# Elastic Stack Docker Compose

[Docker Compose](https://docs.docker.com/compose/) configuration to run the "ELK" stack components.

Runs:

* [Elasticsearch](https://www.elastic.co/elasticsearch)
* [The Elastic Distribution of OpenTelemetry Collector](https://github.com/elastic/opentelemetry)
* [Kibana](https://www.elastic.co/kibana)

### Requirements

* [Docker Compose](https://docs.docker.com/compose/)

### Installation 

```bash
curl && unzip && cd elastic-stack-docker-compose && docker compose up
```

### Usage

* Clone this repository
* `cd elastic-stack-docker-compose`
* `docker compose up`

## Upstream docker-compose.yml configurations

This compose.yaml combines these sources:

* [Elasticsearch](https://github.com/elastic/elasticsearch/blob/8b09e9119d17dcf82a67aaefdcd5ce224a5c8598/docs/reference/setup/install/docker/docker-compose.yml)
* [OpenTelemetry Demo](https://github.com/elastic/opentelemetry-demo/blob/main/docker-compose.yml)
* [Getting started with the Elastic Stack and Docker Compose: Part 1](https://github.com/elkninja/elastic-stack-docker-part-one)
* [Getting started with the Elastic Stack and Docker Compose: Part 2](https://github.com/elkninja/elastic-stack-docker-part-two)

## Inspiration

This aims to be a simplified version of https://github.com/elastic/start-local/ and internal proofs of concept.
