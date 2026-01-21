#!/bin/bash
set -e

echo "🔍 Checking Minikube status..."

# Configuration
PROFILE="lakehouse"
NODES=3
CPUS=3
MEMORY=4096  # 4GB in MB

# Check if minikube is running
if minikube status -p $PROFILE &>/dev/null; then
    echo "✅ Minikube profile '$PROFILE' is already running"
    
    # Verify configuration
    CURRENT_NODES=$(kubectl get nodes --no-headers 2>/dev/null | wc -l)
    
    if [ "$CURRENT_NODES" -eq "$NODES" ]; then
        echo "✅ Minikube has $NODES nodes as expected"
    else
        echo "⚠️  Warning: Minikube has $CURRENT_NODES nodes, expected $NODES"
        echo "   Consider deleting and recreating: ./scripts/00-delete-minikube.sh && $0"
    fi
    
    kubectl get nodes
    exit 0
fi

echo "🚀 Starting Minikube profile '$PROFILE' with $NODES nodes..."
echo "   CPUs: $CPUS per node"
echo "   Memory: ${MEMORY}MB per node"

minikube start \
    -p $PROFILE \
    --nodes=$NODES \
    --cpus=$CPUS \
    --memory=$MEMORY \
    --driver=docker

echo ""
echo "✅ Minikube profile '$PROFILE' started successfully!"
echo ""
kubectl get nodes

echo ""
echo "💡 Minikube is ready for deployment"
