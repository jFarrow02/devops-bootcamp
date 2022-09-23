# Persisting Data in K8s with Volumes

## The Need for Volumes
K8s does not give you data persistence out of the box. You must **configure** it so any data will be available if a pod dies and is recreated. Storage must be available for **all** nodes in the cluster, and survive even if the **whole cluster** crashes.

## Persistent Volumes
Persistent Volumes: a cluster resource used to store data.
- Created using a `.yaml` manifest file.
- Needs actual physical storage or cloud storage; **you** must decide what type, create that, and manage your storage option **yourself**.
- Can have multiple storage locations/types per cluster
- Persistent volumes are NOT namespaced; available to entire cluster
- Provides an **interface** to the **persistent storage** that you, the administrator, create.

### Persistent Volume Types
1. Local: Local types **are** tied to one specific node and **do not** survive cluster crashes

2. Remote/Cloud

3. ConfigMap & Secret

### PersistentVolumeClaim
PVC "claims" a volume. Whatever volume satisfies the claim must be referenced in the Pod manifest configuration.