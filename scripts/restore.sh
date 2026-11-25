#!/usr/bin/env bash
set -euo pipefail
FILE="${1:?Usage: restore.sh backup-file.yaml}"
kubectl apply -f "$FILE"
echo "Restore manifests applied. Verify pods, services, endpoints and application health."
