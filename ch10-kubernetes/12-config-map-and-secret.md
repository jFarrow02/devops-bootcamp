# CopnfigMap & Secret Volume Types

How do we pass config files to Kubernetes Pods? **Config Map** and **Secret**
are used for external configuration of individual key/value pairs, or **files**
that can be acessed by the pod:

- usernames
- passwords
- environment vars
- certificates
- etc.

## When to Use ConfigMap and Secret Volume Types?

- individual key-value pairs
- files that can be mounted in container

`config-file.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mosquito-config-file
data:
  # name of file
  mosquito.conf: |
    log_dest stdout 
    log_type all
    log_timestamp true
    listener 9001
```

`secret-file.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
    name: mosquito-secret-file
type: Opaque
data:
    secret.file: |
    {base-64-secret-string-here}
```

## Mounting the Volumes in the Pod and Containers

`mosquitto.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mosquitto-config-file
data:
  mosquitto.conf: |
    log_dest stdout
    log_type all
    log_timestamp true
    listener 9001

---
apiVersion: v1
kind: Secret
metadata:
  name: mosquitto-secret-file
type: Opaque
data:
  secret.file: |
    c29tZXN1cGVyc2VjcmV0IGZpbGUgY29udGVudHMgbm9ib2R5IHNob3VsZCBzZWU=

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mosquitto
  labels:
    app: mosquitto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mosquitto
  template:
    metadata:
      labels:
        app: mosquitto
    spec:
      containers:
        - name: mosquitto
          image: eclipse-mosquitto:1.6.2
          ports:
            - containerPort: 1883
          volumeMounts:
            - name: mosquitto-conf
              mountPath: /mosquitto/config
            - name: mosquitto-secret
              mountPath: /mosquitto/secret
              readOnly: true
      volumes:
        - name: mosquitto-conf
          configMap:
            name: mosquitto-config-file
        - name: mosquitto-secret
          secret:
            secretName: mosquitto-secret-file

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mosquitto
  labels:
    app: mosquitto
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mosquitto
  template:
    metadata:
      labels:
        app: mosquitto
    spec:
      containers:
        - name: mosquitto
          image: eclipse-mosquitto:1.6.2
          ports:
            - containerPort: 1883
```
