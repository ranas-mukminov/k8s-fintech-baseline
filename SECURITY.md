# Security Policy

## Scope

`k8s-fintech-baseline` ships **example** Kubernetes / Kyverno / NetworkPolicy manifests for educational and starter-pack use. They are **not** certified PCI-DSS controls.

## Reporting a vulnerability

If you discover a security issue in this repository (e.g. a policy that silently fails open, a dangerous default, or docs that could cause production outage):

1. **Prefer private disclosure**: email via the contact on [run-as-daemon.dev](https://run-as-daemon.dev) or open a GitHub Security Advisory on this repo if enabled.
2. Include: affected file/path, expected vs actual behavior, and a minimal repro (non-prod).
3. Do **not** open a public issue that includes production cluster details, secrets, or live CDE topology.

We aim to acknowledge reports within a reasonable time and fix high-impact issues promptly.

## Operational warning

Applying `policies/network/deny-all-default.yaml` (or `kubectl apply -k .`) can **block all pod traffic** in the target namespace. Always stage in non-production. See the README apply order.

## Out of scope

- Misconfiguration of *your* cluster after adapting these examples
- Third-party tools (Kyverno, CNI, Helm charts) — report upstream
- Claims of compliance certification (this project makes none)
