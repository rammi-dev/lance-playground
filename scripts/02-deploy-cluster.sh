#!/bin/bash
set -e

echo "🚀 Deploying Ceph Cluster..."

# Check if operator is running
if ! kubectl get deployment rook-ceph-operator -n rook-ceph &> /dev/null; then
    echo "❌ Error: Rook operator not found. Please run 01-deploy-operator.sh first."
    exit 1
fi

# Deploy cluster
echo "📦 Installing Ceph Cluster via Helm..."
helm upgrade --install ceph-cluster helm/ceph-cluster \
  -n rook-ceph

# Wait for cluster to be ready
echo "⏳ Waiting for Ceph cluster to be ready (this may take 2-3 minutes)..."
sleep 10

# Monitor cluster status
echo "📊 Monitoring cluster creation..."
for i in {1..30}; do
    STATUS=$(kubectl -n rook-ceph get cephcluster rook-ceph -o jsonpath='{.status.phase}' 2>/dev/null || echo "Pending")
    echo "  Status: $STATUS"
    
    if [ "$STATUS" = "Ready" ]; then
        echo "✅ Ceph Cluster is ready!"
        break
    fi
    
    if [ $i -eq 30 ]; then
        echo "⚠️  Cluster not ready yet. Check status with: kubectl -n rook-ceph get cephcluster"
    fi
    
    sleep 10
done

echo ""
echo "📋 Cluster Pods:"
kubectl -n rook-ceph get pods

echo ""
echo "📋 Cluster Status:"
kubectl -n rook-ceph get cephcluster
