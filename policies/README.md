# Policies index (EXAMPLES)

> **All manifests under `policies/` are EXAMPLES.** They illustrate common FinTech/PCI-oriented hardening patterns. They are **not** certified PCI-DSS controls and do **not** guarantee compliance.

## Layout

| File | Kind | Scope | Notes |
|------|------|-------|-------|
| [`pss/restricted-baseline.yaml`](pss/restricted-baseline.yaml) | Kyverno `ClusterPolicy` | Cluster | Non-root, drop ALL caps, no privileged, RO rootfs |
| [`pss/require-ro-rootfs.yaml`](pss/require-ro-rootfs.yaml) | Kyverno `ClusterPolicy` | Cluster | Standalone RO rootfs (optional) |
| [`pss/disallow-hostpath.yaml`](pss/disallow-hostpath.yaml) | Kyverno `ClusterPolicy` | Cluster | No hostPath volumes |
| [`pss/disallow-privileged-ports.yaml`](pss/disallow-privileged-ports.yaml) | Kyverno `ClusterPolicy` | Cluster | containerPort ≥ 1024 |
| [`rbac/deny-cluster-admin-binding.yaml`](rbac/deny-cluster-admin-binding.yaml) | Kyverno `ClusterPolicy` | Cluster | Deny bindings to `cluster-admin` |
| [`network/deny-all-default.yaml`](network/deny-all-default.yaml) | `NetworkPolicy` | `fintech-workloads` | **WARNING** default-deny ingress+egress |
| [`network/allow-dns.yaml`](network/allow-dns.yaml) | `NetworkPolicy` | `fintech-workloads` | DNS egress UDP/TCP 53 |
| [`network/allow-https-egress.yaml`](network/allow-https-egress.yaml) | `NetworkPolicy` | `fintech-workloads` | HTTPS egress TCP 443 |
| [`network/allow-same-namespace.yaml`](network/allow-same-namespace.yaml) | `NetworkPolicy` | `fintech-workloads` | Optional same-ns traffic |

## Suggested apply order

1. Create namespace: `kubectl apply -f ../examples/namespace.yaml`
2. Install Kyverno (see root README).
3. Apply PSS + RBAC ClusterPolicies.
4. Apply network policies **in a test namespace first**:
   - `deny-all-default.yaml` ⚠️
   - then `allow-dns.yaml`, `allow-https-egress.yaml`, and optionally `allow-same-namespace.yaml`

Or use kustomize from repo root: `kubectl apply -k .` (same WARNING).

Default-deny without allow rules will break pod egress (and often ingress). Always stage in non-prod.
