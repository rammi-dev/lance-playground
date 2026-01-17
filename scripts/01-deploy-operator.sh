#!/bin/bash
set -e

echo "🚀 Deploying Rook Operator..."

# Check if namespace exists
if ! kubectl get namespace rook-ceph &> /dev/null; then
    echo "📦 Creating namespace rook-ceph..."
    kubectl create namespace rook-ceph
fi

# Deploy operator
echo "📦 Installing Rook Operator via Helm..."
helm upgrade --install rook helm/rook \
  -f helm/rook/values-override.yaml \
  -n rook-ceph

# Wait for operator to be ready
echo "⏳ Waiting for operator pod to be ready..."
kubectl wait --for=condition=ready pod \
  -l app=rook-ceph-operator \
  -n rook-ceph \
  --timeout=300s

echo "✅ Rook Operator deployed successfully!"
kubectl -n rook-ceph get pods
