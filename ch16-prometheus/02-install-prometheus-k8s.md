# Install Prometheus Stack in K8s

We will deploy a Prometheus stack in K8s.

## How to Deploy Different Parts in K8s

1. Creating all configuration YAML files and execute them in right order (**not
   recommended**)

2. Using an **Operator**. An operator is a manager of all Prometheus components
   that make up the stack as **one unit** that you create.

3. Use a **Helm chart** to deploy the operator.

## Demo Overview

1. Deploy microservices application (from K8s module) in EKS

2. Deploy Pronetheus stack

3. Monitor K8s cluster

4. Monitor ms application inside the cluster

### Create EKS Cluster

- `eksctl create cluster`: Create an EKS cluster in the default region with the
  default AWS credentials.

### Deploy MS Application

- `kubectl apply -f config-microservices.yaml`: Use the file that you created in
  the K8s module.

### Deploy Prometheus Stack w/ Helm Chart

- `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`

- `kubectl create namespace monitoring`

- `helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring`

- `kubectl get all -n monitoring`

## Understanding Prometheus Stack Components

2 `StatefulSets`:

1. Prometheus server
2. Alert Manager

3 `Deployments`:

1. Prometheus Operator: created prometheus and alert manager `StatefulSet`
2. Grafana
3. Kube State Metrics: allows Prometheus to scrape

3 `ReplicaSets`

1 `DaemonSet`:

1. Node exporter daemon set: Runs on every worker node. Connects to server and
   translates Worker Node metrics to Prometheus metrics

Pods and Services as necessary. With this monitoring stack, both the worker
nodes and k8s components are monitored.
