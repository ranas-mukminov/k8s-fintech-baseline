# Quick start (non-prod)

> **EXAMPLES only — not certified PCI compliance.** Stage everything in a throwaway namespace or cluster first. Default-deny NetworkPolicies will break traffic until allow rules exist.

## Prerequisites

- `kubectl` with access to a **non-production** cluster
- [Kyverno](https://kyverno.io/) installed (Helm example below)
- Optional locally: `kyverno` CLI, `make`, Python 3 + PyYAML

## 10-minute path

```bash
# 0. Clone
git clone https://github.com/ranas-mukminov/k8s-fintech-baseline.git
cd k8s-fintech-baseline

# 1. Validate without a cluster
make validate
# or: ./scripts/validate.sh

# 2. Install Kyverno (pin a version your team trusts)
helm repo add kyverno https://kyverno.github.io/helm-charts
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace

# 3. Preview manifests (no apply)
make kustomize-starter   # writes /tmp/k8s-fintech-starter.yaml
# or stricter isolation (no same-namespace allow):
make kustomize-strict

# 4. Apply STARTER overlay to non-prod only
# WARNING: includes default-deny for namespace fintech-workloads
kubectl apply -k overlays/starter --load-restrictor=LoadRestrictionsNone

# 5. Smoke-check
kubectl get clusterpolicy
kubectl get networkpolicy -n fintech-workloads
kubectl get ns fintech-workloads --show-labels
```

## Choose an overlay

| Overlay | Includes same-namespace allow? | Use when |
|---------|--------------------------------|----------|
| `overlays/starter` (also root `.`) | Yes | First demos, east-west within ns OK |
| `overlays/strict` | No | Stronger isolation; add explicit NetPols |
| `overlays/fintech-baseline` | No | Compat alias → `strict` |

## Customize before production

1. Edit `policies/pss/image-registry-allowlist.yaml` — replace `TODO` / `ALLOWED_REGISTRY_*` prefixes, then consider `Enforce`.
2. Review `disallow-exec` exclusions for break-glass / platform namespaces.
3. Flip `require-probes` from `Audit` → `Enforce` when probes exist.
4. Narrow `allow-https-egress` (CIDRs / FQDNs via CNI-specific policy if available).
5. Replace example namespace name/labels to match your org.

## Undo (non-prod)

```bash
kubectl delete -k overlays/starter --load-restrictor=LoadRestrictionsNone
# ClusterPolicies are cluster-scoped — confirm deletion:
kubectl get clusterpolicy
```

## Next

- Policy index: [`policies/README.md`](../policies/README.md)
- PCI themes (educational only): [`PCI-MAPPING.md`](PCI-MAPPING.md)
- Related host hardening: [ssh-harden](https://github.com/ranas-mukminov/ssh-harden)
