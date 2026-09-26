# k8s-fintech-baseline

**PCI/FinTech-oriented Kubernetes security baseline** — example Kyverno Pod Security Standards (PSS) policies, default-deny NetworkPolicies, and a starter namespace pack.

> **Examples only — not certified PCI compliance.** These manifests illustrate common hardening patterns. They do **not** constitute legal advice, a compliance audit, or a claim that your environment meets PCI-DSS (or any other standard). Adapt, review, and validate with your security/compliance team.

---

## The problem

FinTech and payment workloads on Kubernetes often start with:

- Privileged or root containers by default
- Wide-open pod-to-pod networking
- Ad-hoc NetworkPolicies that never cover DNS, monitoring, or ingress
- “We’ll add PSS later” — until an auditor asks

This repo gives you a **small, opinionated starter pack** so platform and AppSec teams can enforce restricted-ish PSS via Kyverno and apply cautious default-deny networking — without pretending one YAML file equals certification.

## Who it’s for

- Platform / SRE teams running payment or cardholder-data adjacent workloads
- DevSecOps engineers introducing Kyverno + NetworkPolicy in regulated environments
- FinTech startups that need a **baseline**, not a 200-page binder

## What’s included

| Path | Purpose |
|------|---------|
| [`policies/pss/restricted-baseline.yaml`](policies/pss/restricted-baseline.yaml) | Example Kyverno `ClusterPolicy` — non-root, drop ALL caps, no privileged |
| [`policies/network/deny-all-default.yaml`](policies/network/deny-all-default.yaml) | Default-deny ingress **and** egress for `fintech-workloads` |
| [`policies/network/allow-dns.yaml`](policies/network/allow-dns.yaml) | Allow DNS egress (so default-deny does not break name resolution) |
| [`examples/namespace.yaml`](examples/namespace.yaml) | Sample `Namespace` with labels |
| [`policies/README.md`](policies/README.md) | Policy index and apply order |

All policies are clearly marked as **EXAMPLES**. Apply carefully in non-prod first.

## Quick start (Kyverno)

```bash
# 1. Install Kyverno (example — pin a version you trust)
helm repo add kyverno https://kyverno.github.io/helm-charts
helm repo update
helm install kyverno kyverno/kyverno -n kyverno --create-namespace

# 2. Create the example namespace
kubectl apply -f examples/namespace.yaml

# 3. Apply PSS baseline ClusterPolicy (cluster-scoped)
kubectl apply -f policies/pss/restricted-baseline.yaml

# 4. Network policies — apply carefully; default-deny will block traffic
kubectl apply -f policies/network/deny-all-default.yaml
kubectl apply -f policies/network/allow-dns.yaml
```

**Order matters for NetworkPolicies:** after default-deny, workloads need explicit allow rules (DNS is included as a minimal example). Test in a dedicated namespace before production.

## High-level map to PCI-DSS themes

| Theme (illustrative) | How this repo helps (examples) |
|----------------------|--------------------------------|
| Restrict access / least privilege | Non-root, no privileged, drop capabilities |
| Segment cardholder / sensitive environments | Namespace isolation + default-deny NetworkPolicies |
| Harden systems | PSS-style admission controls via Kyverno |
| Document & control change | Git-managed policies as code |

This mapping is **educational and incomplete**. It is **not** a PCI-DSS control matrix and **not** legal or QSA advice.

## Project & contact

- Site: [run-as-daemon.ru](https://run-as-daemon.ru) · [run-as-daemon.dev](https://run-as-daemon.dev)
- Author: [ranas-mukminov](https://github.com/ranas-mukminov) (Run_as_daemon / Ranas Security)

## License

MIT — see [`LICENSE`](LICENSE). Copyright © 2026 Run_as_daemon / ranas-mukminov.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md). PRs that keep examples safe, labeled, and non-claiming “certified” are welcome.

---

### If this helped — star the repo

Stars help others find a practical FinTech K8s baseline. If you fork or adapt it, a star is appreciated.

---

## Кратко (RU)

Базовый набор **примеров** политик для Kubernetes в FinTech/PCI-контексте: Kyverno (PSS-подобные ограничения) + NetworkPolicy (default-deny + DNS). Это **не** сертифицированный PCI-комплаенс и не юридическая консультация. Сайт: [run-as-daemon.ru](https://run-as-daemon.ru).
