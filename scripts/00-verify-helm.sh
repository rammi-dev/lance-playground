#!/bin/bash
set -e

echo "🔍 Verifying Helm installation..."

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "❌ Helm is not installed"
    echo "💡 Install Helm: https://helm.sh/docs/intro/install/"
    exit 1
fi

echo "✅ Helm is installed"
helm version --short

# Check Helm can access the cluster
echo ""
echo "🔍 Checking Helm cluster access..."

if helm list -A &> /dev/null; then
    echo "✅ Helm can access the cluster"
    echo ""
    echo "📊 Current Helm releases:"
    helm list -A || echo "No releases found"
else
    echo "❌ Helm cannot access the cluster"
    echo "💡 Make sure kubectl is configured: ./scripts/00-verify-kubectl.sh"
    exit 1
fi

echo ""
echo "✅ Helm is properly configured"
