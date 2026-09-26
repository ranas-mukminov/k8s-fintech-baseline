# Contributing

Thanks for helping improve **k8s-fintech-baseline**.

## Guidelines

1. **Keep policies as EXAMPLES** — do not claim PCI certification, legal advice, or “compliance guarantees” in docs or commit messages.
2. Prefer small, reviewable PRs (one policy or doc change per PR when possible).
3. Validate YAML (`kubectl apply --dry-run=server` or Kyverno CLI) before submitting.
4. Document apply order and blast radius for NetworkPolicies (default-deny can break clusters).
5. Use clear comments in manifests marking EXAMPLE / apply carefully.

## How to contribute

1. Fork the repo and create a branch from `main`.
2. Make your change.
3. Open a pull request describing *what* and *why*.

Questions or ideas: open an issue, or see [run-as-daemon.ru](https://run-as-daemon.ru).
