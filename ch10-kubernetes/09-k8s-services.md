# K8s Services

## What is a Service? Why do we Need Them?

In K8s, each pod has its own IP address. Pods get destroyed frequently. Services
provide a persistent, stable IP address.

Services also provide load balancing. Service receives requests bound for pods
and forwards to available replica pods.

Loose coupling inside and outside (browser requests to cluster, external DBs,
etc) of cluster. Facilitate communication inside and outside of cluster

## Service Types

1. **ClusterIP** Type: Default type. The ClusterIP service receives an IP
   address and port through which it is accessible **within the cluster**.
   Service forwards request to one of the available pods in the cluster.

### Networing in a ClusterIP service - How it Works:

1. Pod is assigned an IP address from a range of addresses assigned to the
   worker node.
2. Each container on the pod exposes a port through which it receives requests.
3. The container can be accessed at the IP address/port combination
4. Request comes in from browser to container via an Ingress. Ingress forwards
   the request to the Service.
5. Service is also accessible at a specific IP address/port withing the cluster.
6. DNS resolution maps service's name to the correct IP address.
7. Service load balances request to a pod.

![cluster ip diagram](/ch10-kubernetes/cluster-ip.png)

**How does the service know which Pod to forward the request to?** Through
"selectors". Pods are identified via **selectors** in the config `.yaml` file
via `selector`. Selectors are key-value pairs that act as **labels** for Pods.
In service `.yaml`, define a `selector` attribute that matches the pod label.
**Note**: If the pod(s) have multiple selectors, the `selector` attributes on
the service **MUST** match **all** the pod selectors!

**What if a pod has multiple ports?** In selector `.yaml` file, define a
`targetPort` attribute. This finds all the pods that match `selector`, picks one
port that matches randomly, and sends request to that pod on the `targetPort`
port.

![multi port diagram](/ch10-kubernetes/multi-port.png)

2. Headless Type: For use when **direct communication with a specific Pod is
   necessary**, e.g.:

   - Client wants to communicate w/ a specific Pod directly
   - Pods want to talk directly w/ other Pods
   - Example: deploying stateful applications like databases, Pod replicas will
     not be identical (each will have its own state)

   In this case, the client needs to know the IP address of each Pod. K8s allows
   clients to discover Pod addrs through DNS lookup; must set `ClusterIP`
   property to "None" to return Pod IP address.

3. Node Port Type: Creates a service accessible to **external** traffic on a
   static port attached to each Worker node. Browser requests come directly to
   Worker node (instead of Ingress). `nodePort` value must be betw 30000-32767.

**Note**: Inefficient, insecure because you are opening the node directly to
outside clients.NOT for production use cases.

4. LoadBalancer Type: A better alternative to Node Port type. Service becomes
   accessible externally through cloud provider's (AWS, GCP, Azure, etc.) Load
   Balancing functionality.

- ClusterIP/NodePort services are created automatically, and the cloud
  provider's load balancing service automatically routes traffic to the created
  service.
