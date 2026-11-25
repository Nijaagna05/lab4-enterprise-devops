#!/usr/bin/env bash
set -euo pipefail
NAMESPACE="${1:-lab4}"
echo "Checking deployments..."
kubectl get deployments -n "$NAMESPACE"
echo "Checking pods..."
kubectl get pods -n "$NAMESPACE"
echo "Checking services and endpoints..."
kubectl get svc,endpoints -n "$NAMESPACE"
