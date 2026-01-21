#!/bin/bash
set -e

PROFILE="lakehouse"

echo "🗑️  Deleting Minikube profile '$PROFILE'..."

if minikube status -p $PROFILE &>/dev/null; then
    minikube delete -p $PROFILE
    echo "✅ Minikube profile '$PROFILE' deleted successfully"
else
    echo "ℹ️  Minikube profile '$PROFILE' does not exist or is not running"
fi

echo ""
echo "💡 Start a new cluster with: ./scripts/00-start-minikube.sh"
