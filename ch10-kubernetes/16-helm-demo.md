# Helm Demo - Managed K8s Cluster

## Overview

1. Deploy mongodb using Helm
2. 3 replicas using StatefulSet
3. Configure data persistence w/ Linode cloud storage
4. Deploy mongo-express UI client
5. Configure nginx-ingress for mongo-express client

Almost 100% of this setup is what you'd need for any solution as a K8s cluster.

## Step 1: Create K8s cluster on LKE

1. `cloud.linode.com` > Kubernetes > Create your K8s cluster
2. Download `Kubeconfig` file from Linode K8s cluster dashboard
3. Set KUBECONFIG env var to Kubeconfig file path:

   - `export KUBECONFIG={kubeconfig-file-path}` **NOTE**: You may need to switch
     contexts in `kubectl` as below:

   ![switch-context](./switch-context.png)

4. You can now connect to your remote K8s environment on Linode from your local
   machine:
   - `kubectl get node` --> Displays your Linode K8s nodes

## Step 2: Deploy MongoDB StatefulSet

Use a bundle of pre-made config files (Helm Chart) to create your StatefulSet:

1. Install `helm` (if not already installed):
   - `brew install helm`
2. Search for the Helm Chart for mongodb
3. Add mongodb Helm Repo (NOTE: the helm and kubectl commands will execute
   against the current context/cluster):
   - `helm repo add bitnami https://charts.bitnami.com/bitnami`
4. `helm search repo bitnami/mongo`
5. Override default parameters in Helm Chart with a Values file:

`test-mongodb.yaml`:

```yaml
architecture: replicaset
replicaCount: 3
persistence:
  storageClass: 'linode-block-storage'
auth:
  rootPassword: secret-root-pwd
```

`persistence.storageClass`: - Connects to Linode - Creates physical storage -
attaches to your Pods

_See
[https://github.com/bitnami/charts/tree/master/bitnami/mongodb](https://github.com/bitnami/charts/tree/master/bitnami/mongodb)
for documentation_

6. Execute command to install chart:
   - `helm search repo {chart-name}`: Search for name of chart {chart-name}
7. Install chart in your cluster:

   - `helm install {arbitrary-mongodb-name-in-cluster} --values test-mongodb.yaml {chart-name}`

8. `kubectl get pod`
9. `kubectl get all`
10. `kubectl get secret`

## Deploy MongoExpress

`test-mongo-express.yaml`:

```yaml

apiVersion: apps/v1
kind: Deployment
metadata:
    name: mongo-express
    labels:
        app: mongo-express
spec:
    replicas: 1
    selector:
        matchLabels:
            app: mongo-express
    template:
        metadata:
            labels:
                app: mongo-express
        spec:
            containers:
            - name: mongo-express
              image: mongo-express
              ports:
                - containerPort: 8081
                env:
                - name: ME_CONFIG_MONGODB_ADMINUSERNAME
                  value: root
                - name: ME_CONFIG_MONGODB_SERVER
                  value: mongodb-0.mongodb-headless
                - name: ME_CONFIG_MONGODB_ADMINPASSWORD
                  valueFrom:
                    secretKeyRef:
                        name: mongodb
                        key: mongodb-root-password
---
apiVersion: v1
kind: Service
metadata:
    name: mongo-express-service
spec:
    selector:
        app: mongo-express
    ports:
        - protocol: TCP
          port: 8081
          targetPort: 8081
```

2. `kubectl apply -f test-mongo-express.yaml`

## Deploy Ingress Controller in Linode K8s cluster

Open `mongo-express` cluster to requests coming in from browser using `Ingress`:

1. Use Helm Chart for Ingress Controller:
   - `helm repo add nginx-stable https://helm.nginx.com/stable`
   - `helm repo update`
   - `helm install my-release bitnami/nginx`
   - `kubectl get pod`

## Create Ingress Rule for Access from Browser to MongoExpress

`test-ingress.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    kubernetes.io.ingress.class: nginx
  name: mongo-express
spec:
  rules:
    - host: xxx # Domain address connected to Linode NodeBalancer
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: mongo-express-service
                port:
                  number: 8081
```

2. `kubectl apply -f test-ingress.yaml`

3. Access mongo-express UI with host name configured in test-ingress.yaml in the
   browser.

## Uninstalling Components from a Chart

- `helm ls`
- `helm uninstall {chart-name}`
