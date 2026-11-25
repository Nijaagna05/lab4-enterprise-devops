#!/usr/bin/env bash
set -euo pipefail
NAMESPACE="${1:-lab4}"
TARGET="${2:-green}"
if [[ "$TARGET" != "blue" && "$TARGET" != "green" ]]; then
  echo "Usage: $0 [namespace] blue|green"; exit 2
fi
kubectl -n "$NAMESPACE" rollout status "deployment/app-$TARGET" --timeout=120s
kubectl -n "$NAMESPACE" patch service app-live -p "{\"spec\":{\"selector\":{\"app\":\"lab4-app\",\"version\":\"$TARGET\"}}}"
echo "Service now selects $TARGET. Verify endpoints and application response."
kubectl -n "$NAMESPACE" get endpoints app-live
