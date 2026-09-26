# Policies index (EXAMPLES)

> **All manifests under `policies/` are EXAMPLES.** They illustrate common FinTech/PCI-oriented hardening patterns. They are **not** certified PCI-DSS controls and do **not** guarantee compliance.

## Layout

| File | Kind | Scope | Notes |
|------|------|-------|-------|
| [`pss/restricted-baseline.yaml`](pss/restricted-baseline.yaml) | Kyverno `ClusterPolicy` | Cluster | Require non-root, drop ALL caps, disallow privileged |
| [`network/deny-all-default.yaml`](network/deny-all-default.yaml) | `NetworkPolicy` | Namespace `fintech-workloads` | Default-deny ingress **and** egress — **apply carefully** |
| [`network/allow-dns.yaml`](network/allow-dns.yaml) | `NetworkPolicy` | Namespace `fintech-workloads` | Allow UDP/TCP 53 egress for DNS |

## Suggested apply order

1. Create namespace: `kubectl apply -f ../examples/namespace.yaml`
2. Install Kyverno (see root README).
3. Apply PSS policy: `kubectl apply -f pss/restricted-baseline.yaml`
4. Apply network policies **in a test namespace first**:
   - `deny-all-default.yaml`
   - then `allow-dns.yaml` (and any other allow rules your workloads need)

Default-deny without allow rules will break pod egress (and often ingress). Always stage in non-prod.
