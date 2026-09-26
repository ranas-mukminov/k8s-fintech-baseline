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
  for ov in starter strict fintech-baseline; do
    echo "-- kubectl kustomize overlays/${ov} (LoadRestrictionsNone)"
    if kubectl kustomize "overlays/${ov}" --load-restrictor=LoadRestrictionsNone >/dev/null; then
      echo "  OK  overlays/${ov} builds"
    else
      echo "  FAIL overlays/${ov}"
      fail=1
    fi
  done
  # strict must NOT include same-namespace allow
  strict_out=$(kubectl kustomize overlays/strict --load-restrictor=LoadRestrictionsNone)
  if echo "$strict_out" | grep -q allow-same-namespace-example; then
    echo "  FAIL strict overlay includes allow-same-namespace"
    fail=1
  else
    echo "  OK  strict overlay excludes allow-same-namespace"
  fi
  starter_out=$(kubectl kustomize overlays/starter --load-restrictor=LoadRestrictionsNone)
  if echo "$starter_out" | grep -q allow-same-namespace-example; then
    echo "  OK  starter overlay includes allow-same-namespace"
  else
    echo "  FAIL starter overlay missing allow-same-namespace"
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
  echo "     kubectl apply -k overlays/starter --dry-run=server --load-restrictor=LoadRestrictionsNone"
else
  echo "-- kyverno CLI not found; skip policy unit tests"
  echo "   Install: https://kyverno.io/docs/kyverno-cli/"
  echo "   Then: kyverno test kyverno-tests/   (or: make test)"
fi
echo

if [[ "$fail" -ne 0 ]]; then
  echo "RESULT: FAILED"
  exit 1
fi
echo "RESULT: OK"
echo
echo "WARNING: Do not apply default-deny NetworkPolicies to production without"
echo "staging. See docs/QUICKSTART.md and README.md apply order."
