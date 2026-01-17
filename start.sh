#!/bin/bash
set -e

# Configuration
NODES=3
MEMORY=6144 # 6GB
CPUS=4
DRIVER=docker

echo "🚀 Starting Minikube cluster with $NODES nodes (Memory: ${MEMORY}MB, CPUs: $CPUS)..."

# Check if minikube is running
if minikube status &> /dev/null; then
    echo "⚠️  Minikube is already running. Delete it first if you want a fresh start ('minikube delete')."
    read -p "Do you want to delete the existing cluster? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        minikube delete
    else
        echo "Exiting..."
        exit 0
    fi
fi

# Start Minikube
minikube start \
    --nodes $NODES \
    --memory $MEMORY \
    --cpus $CPUS \
    --driver $DRIVER \
    --addons=ingress,ingress-dns

echo "✅ Minikube cluster started!"
kubectl get nodes

echo "
💡 Next steps:
- Deploy Rook Ceph Operator
- Configure Cluster
"
