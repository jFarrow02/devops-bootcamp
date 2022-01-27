# YAML Configuration File in K8s

## The 3 Parts of a Config File
1. Metadata
2. Specification: all the configuration values for the component
    - Attributes are specific to the component type (deployments, services, etc)
3. Status: **auto-generated** and added by K8s. K8s compares the desired state to actual state and fixes actual state accordingly
    - Status info comes from `etcd` process; holds current state of any K8s component

`deployment-config.yaml`:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16
        ports:
        - containerPort: 8080
```

`service-config.yaml`
```
apiVersion: v1
kind: Service
metadata:
    name: nginx-service
spec:
    selector:
        app: ningx
    ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
```

## Blueprint for Pods (Template)

`spec.template` has its own `metadata` and `spec` sections that are the **templates** for the **pods** created by this deployment.

## Connecting Components: Labels, Selectors, & Ports
`label` metadata key-value pair is assigned in deployment's `metadata`. The label is matched in pods that need to be connected by the deployment in the `selector.matchLabels.app` metadata.

`containerPort` and `targetPort` must match.

`kubectl describe service [service-name]`: Displays status info including TargetPort and Endpoints. Endpoints must be ip addrs and ports of pods to which service must forward the requests.

`kubectl get pod -o wide`: Displays ip addr of pods

`kubectl get deployment [depl-name] -o yaml`: get updated config file for deployment, including most recent config values and **updated status**.

`kubectl delete -f [file-name]`: Delete deployment, service, etc. using the .yaml config file name.