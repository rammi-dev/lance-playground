#!/bin/bash
set -e

echo "🔍 Verifying kubectl access..."

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed"
    echo "💡 Install kubectl: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

echo "✅ kubectl is installed"
kubectl version --client --short 2>/dev/null || kubectl version --client

# Check if kubectl can access the cluster
echo ""
echo "🔍 Checking cluster access..."

if kubectl cluster-info &> /dev/null; then
    echo "✅ kubectl can access the cluster"
    echo ""
    kubectl cluster-info
    echo ""
    echo "📊 Cluster nodes:"
    kubectl get nodes
else
    echo "❌ kubectl cannot access the cluster"
    echo "💡 Make sure Minikube is running: ./scripts/00-check-minikube.sh"
    exit 1
fi

echo ""
echo "✅ kubectl is properly configured"
