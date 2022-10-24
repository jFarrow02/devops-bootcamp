# Helm and Operator Demo

## Setup Prometheus Monitoring in K8s

How to deploy the different parts in a K8s cluster?

1. Create all configuration YAML files yourself, and execute them in right
   order:

   - Inefficient, takes a lot of effort

2. Using an **operator**: a manager of all Prometheus components as one unit.

3. Using **Helm chart** to deploy operator
   - Helm: initial setup
   - Operator: manages running state

## Setup Steps

1. Obtain Helm chart for Prometheus:

```
helm repo add bitnmai https://charts.bitnami.com/bitnami

helm install my-release bitnami/kube-prometheus
```

2. `kubectl get pod`: Examine the created components. The monitoring stack has
   been created, as well as monitoring for the worker nodes and K8s
   configuration.
