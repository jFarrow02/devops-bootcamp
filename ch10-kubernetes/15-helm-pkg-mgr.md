# Helm Package Manager

## Main Concepts of Helm

### What is Helm?
**Helm** is a package manager for K8s. It is a convenient way to package YAML files (manifests) for K8s components and distribute them in public and private repositories.

**Helm Charts** are bundles of these manifests that are available in the Helm reposoitory for use in your projects. You can create your own Helm Charts with Helm, or download and use charts created by others.

You can search **Helm Hub** public registry, or running `helm search <keyword>` for public charts. There are also **private** registry tools for sharing within organizations.

#### Templating Engine
Template manifests for deploying similar components. Defines a common blueprint for the components. Dynamic values are replaced by placeholders: `{{ .Values.<name> }}`. Values are supplied in a `values.yaml` file, or with command line `--set` flag. This is practical for CI/CD automated build pipelines. Instead of having multiple yaml files for each component, you can now have one yaml file and replace the values dynamically with `values.yaml`. Also useful for deploying same applications across different environments.

### Helm Chart Structure
```
|-mychart/ --> directory name is name of chart
    |- Chart.yaml --> metadata about chart
    |- values.yaml --> values for the template files
    |- charts/ --> directory with chart dependencies
    |- templates/ --> directory contains the actual templates
```
### Execute Helm Chart
- `helm install <chartname>`

### Values Injection
- `helm install --values=my-values.yaml <chartname>`: Override values in `values.yaml` with values in `my-values.yaml`
- `helm install --set version=2.0.0` set version directly from command line flag

## Helm Version
- Version 2: Comes in 2 parts:
    1. Client (Helm CLI)
    2. Server (Tiller): **security risk**

- Version 3: Removes Tiller
