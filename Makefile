# k8s-fintech-baseline — local helpers (EXAMPLES only, not PCI certification)
.PHONY: help validate test docs kustomize-starter kustomize-strict clean

HELP_TEXT := \
	validate          YAML parse + kustomize builds + kyverno tests\n\
	test              Kyverno CLI unit tests only\n\
	docs              List documentation entry points\n\
	kustomize-starter Build starter overlay to /tmp\n\
	kustomize-strict  Build strict overlay to /tmp

help:
	@printf "Targets:\n"
	@printf "  $(HELP_TEXT)\n"
	@printf "\nWARNING: applying overlays includes default-deny NetworkPolicies.\n"

validate:
	@bash scripts/validate.sh

test:
	@command -v kyverno >/dev/null || { echo "kyverno CLI required: https://kyverno.io/docs/kyverno-cli/"; exit 1; }
	kyverno test kyverno-tests/

docs:
	@echo "Documentation:"
	@echo "  README.md              — overview, apply order, comparison"
	@echo "  docs/QUICKSTART.md     — 10-minute path (non-prod)"
	@echo "  docs/PCI-MAPPING.md    — high-level PCI themes (NOT certification)"
	@echo "  policies/README.md     — policy index"
	@echo "  CHANGELOG.md           — releases"
	@echo "  SECURITY.md            — reporting"
	@ls -1 docs/*.md 2>/dev/null || true

kustomize-starter:
	@command -v kubectl >/dev/null || { echo "kubectl required"; exit 1; }
	kubectl kustomize overlays/starter --load-restrictor=LoadRestrictionsNone > /tmp/k8s-fintech-starter.yaml
	@wc -l /tmp/k8s-fintech-starter.yaml
	@echo "Wrote /tmp/k8s-fintech-starter.yaml"

kustomize-strict:
	@command -v kubectl >/dev/null || { echo "kubectl required"; exit 1; }
	kubectl kustomize overlays/strict --load-restrictor=LoadRestrictionsNone > /tmp/k8s-fintech-strict.yaml
	@wc -l /tmp/k8s-fintech-strict.yaml
	@echo "Wrote /tmp/k8s-fintech-strict.yaml"
	@if grep -q allow-same-namespace-example /tmp/k8s-fintech-strict.yaml; then \
	  echo "ERROR: strict overlay must not include allow-same-namespace"; exit 1; \
	fi

clean:
	rm -f /tmp/k8s-fintech-starter.yaml /tmp/k8s-fintech-strict.yaml /tmp/kustomize-*.yaml
