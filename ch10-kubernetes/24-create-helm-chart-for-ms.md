# Microservices in K8s: Part 4 Create Helm Chart for Microservices

- 1 Blueprint for Deployment and Service for all MSs

- Set values for individual MSs

Helm Charts allow you to create **reusable configurations** for your MS. Two
options:

1. Create a Helm chart for **each microservice** (useful for when microservices
   are different from one another)

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

## Template File Structure

Create **template files** for `Deployment`, `Service`, and other K8s components
in the `/templates` folder as needed. Use the `{{}}` syntax for template value
placeholders as follows:

`/templates/deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: { { .Values.appName } }
spec:
  replicas: { { .Values.appReplicas } }
  selector:
    matchLabels:
      app: { { .Values.appName } }
  template:
    metadata:
      labels:
        app: { { .Values.appName } }
  spec:
    containers:
      - name: { { .Values.appName } }
        image: '{{ .Values.appImage }}:{{ .Values.appVersion }}' # enclose in double-quotes to concatenate template values
        ports:
          - containerPort: { { .Values.containerPort } }
```

`/templates/service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: { { .Values.appName } }
spec:
  type: { { .Values.serviceType } }
  selector:
    app: { { .Values.appName } }
  ports:
    - protocol: TCP
      port: { { .Values.servicePort } }
      targetPort: { { .Values.containerPort } }
```

`Values` is a built-in object in `helm` that receives values from:

- the `values.yaml` file
- passed from the terminal/command line with the `-f` flag
- parameter passed with the `--set` flag

### Defining the Variables in a Hierarchical Structure

Variable values can be defined in the `values.yaml` file in either a **flat** or
**nested** structure:

```yaml
appName: myapp
appReplicas: 1

# OR

app:
  name: myapp
  replicas: 1
```

**Note that `helm` recommends a _flat_ structure as a best practice.**

## Dynamic Environment Variables

We need to define our environment variables for our deployment and service in
our template files. However, each microservice may not define the same number of
env vars. How do we define a variable number of env vars in a configurable way?

The `range` function is a built-in `helm` function that provides a
`for each`-style loop, to iterate over a "range" or list:

`/templates/deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
 # ...
  spec:
    containers:
      - name: { { .Values.appName } }
        image: '{{ .Values.appImage }}:{{ .Values.appVersion }}'
        ports:
          - containerPort: { { .Values.containerPort } }
        env: # use the range function to loop over the env vars
        {{- range .Values.containerEnvVars}}
          - name: {{ .name }}
            value: {{ .value | quote}} # pipe the value to the quote function to enclose it in double quotes
        {{-end}}
```

## Setting Variable Values

We can now set the variable values. One place to define the **default** variable
values is `values.yaml`. We will **override** these default values for each
specific microservice configuration.

`values.yaml`:

```yaml
appName: servicename
appImage: gcr.io/google-samples/microservices-demo/servicename
appVersion: v.0.0.0
appReplicas: 1
containerPort: 8080
containerEnvVars:
  - name: ENV_VAR_ONE
    value: 'valueone'
  - name: ENV_VAR_TWO
    value: 'valuetwo'

servicePort: 8080
serviceType: ClusterIP
```

## Setting Custom Values for Microservice

Create a **custom** `values.yaml` file (usually outside the chart) as follows:

`email-service-values.yaml`:

```yaml
appName: emailservice
appImage: gcr.io/google-samples/microservices-demo/emailservice
appVersion: v.1.2.0
appReplicas: 2
containerPort: 8080
containerEnvVars:
  - name: PORT
    value: '8080'
  - name: DISABLE_TRACING
    value: '1'
  - name: DISABLE_PROFILER
    value: '1'

servicePort: 5000
serviceType: ClusterIP
```

### Validating a Template File

- `helm template -f {custom-values-file-name}.yaml {chart-name}`: render chart
  templates locally and display the output

- `helm lint -f {custom-values-file-name}.yaml {chart-name}`: checks for errors
  and outputs results

## Deploy Email Service into Cluster

- `helm install -f {values-file-name}.yaml {release-name} {chart-name}`: install
  a chart, override values from a template file with the values stored in
  `values-file-name.yaml`, add a release name

- `helm ls`: Verify that microservice is running

## Deploying All Microservices with a Helm Chart

Create a file for the `Deployment` and `Service` components for each
microservice you wish to build, alongside the `email-service-values.yaml` file
from the previous sections. Deploy each service using the `helm install` command
above.

## Create Redis Helm Chart

Create a parent `charts` directory as follows:

```
|--charts
|----/microservice

```

Inside `charts`, create the `redis` chart:

- `helm create redis`

Remove the default contents of `deployment.yaml` and `service.yaml`.
Parameterize both files as with `email-service` and create the default values in
`/redis/values.yaml`:

`redis-values.yaml`:

```yaml
appName: redis
appImage: redis
appVersion: alpine
appReplicas: 1
containerPort: 6379
volumName: redis-data
conainerMountPath: /data

servicePort: 6379
```

Override the default values in `/redis/values.yaml` in the
`/values/redis-values.yaml` custom values file:

```yaml
appName: redis-cart
appReplicas: 2
```
