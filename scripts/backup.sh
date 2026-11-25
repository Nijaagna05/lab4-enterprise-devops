#!/usr/bin/env bash
set -euo pipefail
NAMESPACE="${1:-lab4}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="${2:-backup-${NAMESPACE}-${STAMP}.yaml}"
kubectl get all,configmaps,services,deployments -n "$NAMESPACE" -o yaml > "$OUT"
echo "Kubernetes resource export written to: $OUT"
echo "NOTE: Persistent volumes and external databases require separate backup procedures."
