#!/bin/bash
set -e

echo "🗑️  Cleaning up Rook Ceph deployment..."

# Delete cluster first
echo "📦 Uninstalling Ceph Cluster..."
helm uninstall ceph-cluster -n rook-ceph 2>/dev/null || echo "Cluster already removed"

# Wait for cluster deletion
echo "⏳ Waiting for cluster resources to be cleaned up..."
sleep 10

# Delete operator
echo "📦 Uninstalling Rook Operator..."
helm uninstall rook -n rook-ceph 2>/dev/null || echo "Operator already removed"

# Delete CRDs (optional - only if you want full cleanup)
read -p "Delete CRDs? This will remove all Ceph definitions (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️  Deleting CRDs..."
    kubectl get crds | grep ceph.rook.io | awk '{print $1}' | xargs kubectl delete crd 2>/dev/null || true
    kubectl get crds | grep objectbucket.io | awk '{print $1}' | xargs kubectl delete crd 2>/dev/null || true
fi

# Delete namespace
echo "🗑️  Deleting namespace..."
kubectl delete namespace rook-ceph 2>/dev/null || echo "Namespace already removed"

echo "✅ Cleanup complete!"
