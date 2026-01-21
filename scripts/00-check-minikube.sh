#!/bin/bash
set -e

PROFILE="lakehouse"

echo "🔍 Checking Minikube profile '$PROFILE' status..."

if minikube status -p $PROFILE &>/dev/null; then
    echo "✅ Minikube profile '$PROFILE' is running"
    echo ""
    minikube status -p $PROFILE
    echo ""
    kubectl get nodes
else
    echo "❌ Minikube profile '$PROFILE' is not running"
    echo ""
    echo "💡 Start it with: ./scripts/00-start-minikube.sh"
    exit 1
fi
