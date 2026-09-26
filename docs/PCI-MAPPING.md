# High-level map to PCI-DSS themes

> **Not certification. Not a QSA workbook. Not legal advice.**
>
> This document maps **illustrative** security themes often discussed alongside
> PCI-DSS to **example** controls in this repository. It is incomplete,
> educational, and **does not** claim that using these manifests achieves
> PCI-DSS compliance or any other certification.

## Theme → example controls

| Theme (illustrative) | Example artifacts in this repo | Notes |
|----------------------|--------------------------------|-------|
| Least privilege / restrict access | `restricted-baseline` (non-root, drop ALL, no privileged), `disallow-exec`, `deny-cluster-admin-binding` | Admission + RBAC guardrails; tune break-glass |
| Harden systems & containers | `disallow-hostpath`, `disallow-privileged-ports`, `require-ro-rootfs`, `disallow-latest-tag` | Complements node CIS tools (e.g. kube-bench) — does not replace them |
| Segment sensitive environments | Namespace labels + `deny-all-default` + DNS/HTTPS allows; `overlays/strict` | NetworkPolicy depends on CNI enforcement |
| Protect against malware / untrusted images | `image-registry-allowlist` (stub — **TODO** your registries), pinned tags | Pair with image scanning / signing (not in this repo) |
| Capacity / availability hygiene | `require-resource-requests`, `require-resource-limits`, `require-probes` (Audit) | Operational resilience themes, not a control matrix |
| Change control & documentation | Git-managed policies, CI (`kyverno test`), `CHANGELOG` | Evidence of process — your org still owns the SDLC |

## Explicitly out of scope

- Cardholder data environment (CDE) scoping and data-flow diagrams
- Encryption, key management, HSM, tokenization
- Logging/SIEM retention, time sync, anti-malware agents
- Physical security, HR, vendor management
- Formal PCI-DSS Requirements / Testing Procedures mapping
- Any statement that this baseline is “PCI compliant” or “certified”

## Suggested reading order

1. [`QUICKSTART.md`](QUICKSTART.md) — apply safely in non-prod
2. Root [`README.md`](../README.md) — architecture and comparison
3. Your QSA / internal compliance program — for actual assessments

## Related (host layer)

Node and SSH hardening are outside Kubernetes admission control. See
[ssh-harden](https://github.com/ranas-mukminov/ssh-harden) and
[AutoHarden-Toolkit](https://github.com/ranas-mukminov/AutoHarden-Toolkit)
for CIS-oriented **examples** at the OS layer (also not certification).
