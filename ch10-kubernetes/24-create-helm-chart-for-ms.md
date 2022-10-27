# Microservices in K8s: Part 4 Create Helm Chart for Microservices

- 1 Blueprint for Deployment and Service for all MSs

- Set values for individual MSs

Helm Charts allow you to create **reusable configurations** for your MS. Two
options:

1. Create a Helm chart for **each microservice**

2. Create a **shared Helm chart** for all microservices (useful for when
   microservices share similar configurations)

## Basic Structure of Helm Chart

- `helm create {chart-name}`

Creates a new folder `{chart-name}` with the following structure:

```
|- chart-name
|----\ charts # Holds chart dependencies
|----\ templates # core of the Helm charts where the actual K8s YAML files are created
|----\ .helmignore # ignores files you don't want to include in your helm chart when building a package archive from this chart
|----\ Chart.yaml # Meta info about the chart
|----\ values.yaml # actual values for template files
```

- `helm template -f {template-file-name}.yaml {chart-name}`: render chart
  templates locally and display the output

- `helm lint -f {template-file-name}.yaml {chart-name}`: checks for errors and
  outputs results

## Deploy Email Service into Cluster

- `helm install -f {template-file-name}.yaml {release-name} {chart-name}`

- `helm ls`: Verify that chat is running
