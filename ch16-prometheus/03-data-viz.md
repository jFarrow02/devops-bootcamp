# Data Visualization with Prometheus

## How to Decide What to Monitor?

We want to know when something **unexpected** Happnens, in the **cluster nodes**
or in the **applications** running in the cluster:

- CPU spikes
- insufficient storage
- higher than normal traffic
- too many unauthenticated requests
- etc.

You want to analyze these things and **react accordingly**.

## How to Get this Information

You need **visibility** of this monitoring data, somewhere in a human-readable
way!

Prometheus has a **Web UI**:

- `kubectl port-forward service/monitoring-kube-prometheus-prometheus -n monitoring 9090:9090 &`:
  You can now see Prometheus UI in your browser at `127.0.0.1:9090`

- `127.0.0.1:9090/targets`: View the targets that Prometheus is currently
  monitoring
