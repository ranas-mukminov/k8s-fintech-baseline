# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/).

## [0.2.0] — 2026-09-26

### Added

- Kyverno examples: `disallow-latest-tag`, `require-resource-limits`, `require-resource-requests`, `disallow-exec` (Pod/exec+attach), `require-probes` (optional Audit), `image-registry-allowlist` stub with TODO comments (Audit)
- Kustomize `base/` + overlays `starter` (same-ns allow) and `strict` (no same-ns); `fintech-baseline` kept as compat alias → strict
- `Makefile` with `validate`, `test`, `docs`, `kustomize-starter`, `kustomize-strict`
- `docs/QUICKSTART.md` and `docs/PCI-MAPPING.md` (high-level themes only — not certification)
- Expanded `kyverno-tests/` for new policies (latest tag, resources, probes, hostPath, privileged ports)
- README: asciinema-style demo, comparison vs kube-bench / Kyverno / policies, clearer star CTA, link to ssh-harden

### Changed

- Root `kustomization.yaml` includes new PSS policies (starter-equivalent)
- CI builds all overlays and runs `make` targets; validate.sh checks starter vs strict same-ns behavior
- `policies/README.md` index updated

### Notes

- All policies remain **EXAMPLES**. No PCI certification claims. Registry allowlist and probes stay Audit until customized.

## [0.1.0] — 2026-09-26

### Added

- Expanded Kyverno PSS examples: RO rootfs in restricted baseline, `require-ro-rootfs`, `disallow-hostpath`, `disallow-privileged-ports`
- NetworkPolicy examples: `allow-https-egress`, `allow-same-namespace` (optional)
- RBAC Kyverno example: `deny-cluster-admin-binding`
- Root `kustomization.yaml` and stricter `overlays/fintech-baseline`
- `scripts/validate.sh` (YAML parse, kustomize build, kyverno test notes)
- Kyverno CLI unit tests under `kyverno-tests/` (no cluster)
- GitHub Actions CI (YAML parse, kustomize, Kyverno CLI tests)
- `SECURITY.md`, badges and architecture diagram in README

### Notes

- All policies remain **EXAMPLES**. No PCI certification claims.
- Initial scaffold (PSS restricted + default-deny + DNS) was committed prior to this release tag.
