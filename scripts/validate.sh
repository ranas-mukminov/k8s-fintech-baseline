#!/usr/bin/env bash
# EXAMPLE validation helper for k8s-fintech-baseline.
# Does NOT apply policies to a live cluster by default.
# Requires: python3 + PyYAML. Optional: kubectl, kyverno CLI.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "==> k8s-fintech-baseline validate"
echo "    repo: $ROOT"
echo

fail=0

echo "-- YAML syntax (python3)"
if python3 - <<'PY'
import sys, pathlib
try:
    import yaml
except ImportError:
    print("PyYAML not installed; skip (pip install pyyaml)")
    sys.exit(0)

root = pathlib.Path(".")
errors = []
for p in sorted(root.rglob("*.yaml")):
    if ".git" in p.parts:
        continue
    try:
        with p.open() as f:
            list(yaml.safe_load_all(f))
        print(f"  OK  {p}")
    except Exception as e:
        errors.append(f"  FAIL {p}: {e}")
        print(f"  FAIL {p}: {e}", file=sys.stderr)
sys.exit(1 if errors else 0)
PY
then
  echo "YAML parse: OK"
else
  echo "YAML parse: FAILED"
  fail=1
fi
echo

if command -v kubectl >/dev/null 2>&1; then
  echo "-- kubectl kustomize ."
  if kubectl kustomize . >/dev/null; then
    echo "  OK  root kustomization builds"
  else
    echo "  FAIL root kustomization"
    fail=1
  fi
  echo "-- kubectl kustomize overlays/fintech-baseline (LoadRestrictionsNone)"
  if kubectl kustomize overlays/fintech-baseline --load-restrictor=LoadRestrictionsNone >/dev/null; then
    echo "  OK  overlay builds"
  else
    echo "  FAIL overlay"
    fail=1
  fi
else
  echo "-- kubectl not found; skip kustomize build"
fi
echo

if command -v kyverno >/dev/null 2>&1; then
  echo "-- kyverno CLI detected"
  if [[ -d kyverno-tests ]]; then
    echo "   Running: kyverno test kyverno-tests/"
    if kyverno test kyverno-tests/; then
      echo "  OK  kyverno test"
    else
      echo "  FAIL kyverno test"
      fail=1
    fi
  fi
  echo
  echo "   Cluster dry-run (optional, needs kubeconfig + Kyverno CRDs):"
  echo "     kyverno apply policies/pss/ --dry-run"
  echo "     kubectl apply -k . --dry-run=server"
else
  echo "-- kyverno CLI not found; skip policy unit tests"
  echo "   Install: https://kyverno.io/docs/kyverno-cli/"
  echo "   Then: kyverno test kyverno-tests/"
fi
echo

if [[ "$fail" -ne 0 ]]; then
  echo "RESULT: FAILED"
  exit 1
fi
echo "RESULT: OK"
echo
echo "WARNING: Do not apply default-deny NetworkPolicies to production without"
echo "staging. See README.md apply order."
