# Intro to Monitoring with Prometheus

## What is Prometheus?

**Prometheus** was created to monitor container environments such as K8s,
docker-swarm, etc.

## Where and Why is Prometheus Used?

Typically a devops environment may have multiple servers distributed over many
locations, running 100s, 1000s of containers. Any one of them can crash and
cause failure of others. How do we quickly identify what went wrong, and where?

A tool that constantly monitors all the services and alerts sys admins when
crashes happen, **or identifies problems _before_ they occur and sends alerts to
sys admins** helps us avoid such problems!

## Prometheus Architecture

### Prometheus Server

**Prometheus Server** monitors a particular **target**: Linux/Windows servers,
databases, application, etc. It monitors metrics of that target such as:

- CPU status
- memory/disk space usage
- Exceptions count
- Requests count
- Request duration etc.

![prometheus server](./screenshots/prometheus-server-2 .png)

Prometheus saves these **metrics** as follows:

![prometheus metrics](./screenshots/prometheus-metrics.png)

Prometheus pulls metrics from HTTP endpoints. Some services need an `Exporter`
component that fetches metrics from the target, and exposes the metrics at an
endpoint where Pro can access them. For example, if you want to monitor a Linux
server you can download a `node Exporter`, untar and execute it on your server.
It will convert the metrics of the server and expose the `/metrics` endpoint.
You can then configure Pro to scrape that endpoint. Exporters are also available
as Docker images.

## Monitoring your Own Applications

Pro **client libraries** for various programming languages (Node, Java, etc.)
allow you to expose a `/metrics` endpoint to which your application can emit
relevant metrics to be monitored.

## Pull System for Metrics
