# Deploy Microservices with Helmfile

Now that we have our Redis chart and Microservices chart, we are ready to deploy
them. We have two options for deploying:

## Deploy with `helm install`

We can use the `helm install` command for each values file in the `values`
directory:

```
helm install -f {values-file-name}.yaml {release-name} {chart-name}
```

- `helm install -f values/redis-values.yaml redischart charts/redis`

We can do this manually, or write a `bash` script that executes `helm install`
command for each microservice and redis.

`helm install` will _work_, but it's not the _most efficient way_ of
installing/uninstalling multiple release with a single command. There is another
way.

### Uninstalling Helm Charts

- `helm uninstall {release-name}`: Run this command for each release, or write a
  script.

## Deploy with a Helmfile

A **Helmfile** is a declarative way for deploying helm charts. Similarly to K8s
manifests, a helmfile is a `yaml` file that defines the **desired state** of the
releases:

`helmfile.yaml`:

```yaml
releases:
  - name: emailservice
    chart: ./charts/app
    values:
      - ./values/emailservice.yaml
  - name: paymentservice
    chart: ./charts/app
    values:
      - ./values/paymentservice.yaml
  # ...
```

The `helmfile` allows you to:

- Declare a definition of an entire K8s cluster

- Change specification depending on application or type of environment

### Create Helmfile

Create `helmfile.yaml` in your project root:

```
|--microservices
|----\charts
|----\values
|----\config.yaml
|----\helmfile.yaml

```

`helmfile.yaml`:

```yaml
releases:
  - name: rediscart
    chart: charts/redis
    values:
      - values/redis-values.yaml
      - appReplicas: '1'
      - volumeName: 'redis-cart-data' # override defined values as desired

  - name: emailservice
    chart: charts/microservice
    values:
      - values/email-service-values.yaml

  - name: cartservice
    chart: charts/microservice
    values:
      - values/cart-service-values.yaml

  # configure remaining releases...
```

### Install `helmfile` CLI Tool

See [Helm Installation Docs](https://github.com/helmfile/helmfile) for
instructions on how to install for your OS.

#### Run `helmfile` as Docker Container

- `docker pull ghcr.io/helmfile/helmfile:v0.147.0`

- `docker run --rm --net=host -v "${HOME}/.kube:/root/.kube" -v "${HOME}/.config/helm:/root/.config/helm" -v "${PWD}:/wd" --workdir /wd ghcr.io/helmfile/helmfile:canary helmfile sync`

## Deploy Releases with `helmfile`

- `helmfile sync`: Helmfile will compare the actual state of the cluster with
  the desired state defined by the helmfile, and update the cluster state to
  match the desired state.

- `helmfile list`: Displays the current releases managed by helmfile in the
  cluster

## Uninstall Releases

- `helmfile destroy`: Removes all helmfile managed releases in the cluster

## Wrap Up

### Where do we Host our Helm Charts?

Helm Charts should be hosted in a **code repository** such as Github. You can
host it **with your application code**, or have a **separate code repo for your
Helm Charts**(preferred).

### How Does it Fit into CI/CD Workflow?

Typically, the DevOps engineer creates Helm Charts for the developers, and
stores them in a separate repository. Application developers are the
**consumers** of the charts, and can modify the configuration/env vars as they
need to.
