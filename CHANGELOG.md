# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/).

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

## [Unreleased]

- Nothing yet.
