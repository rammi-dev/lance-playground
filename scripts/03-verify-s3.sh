#!/bin/bash
set -e

echo "🔍 Verifying S3 Object Store..."

# Check if cluster is ready
CLUSTER_STATUS=$(kubectl -n rook-ceph get cephcluster rook-ceph -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")

if [ "$CLUSTER_STATUS" != "Ready" ]; then
    echo "❌ Error: Ceph cluster is not ready. Current status: $CLUSTER_STATUS"
    exit 1
fi

# Check object store
echo "📊 Object Store Status:"
kubectl -n rook-ceph get cephobjectstore

# Check RGW pods
echo ""
echo "📋 RGW Pods:"
kubectl -n rook-ceph get pods -l app=rook-ceph-rgw

# Get S3 endpoint
MINIKUBE_IP=$(minikube ip)
S3_ENDPOINT="http://${MINIKUBE_IP}:30000"

echo ""
echo "✅ S3 Object Store Information:"
echo "   Endpoint: $S3_ENDPOINT"
echo "   Store Name: my-store"
echo ""
echo "📝 Next Steps:"
echo "   1. Create an object store user:"
echo "      kubectl apply -f - <<EOF"
echo "apiVersion: ceph.rook.io/v1"
echo "kind: CephObjectStoreUser"
echo "metadata:"
echo "  name: my-user"
echo "  namespace: rook-ceph"
echo "spec:"
echo "  store: my-store"
echo "  displayName: \"My S3 User\""
echo "EOF"
echo ""
echo "   2. Get credentials:"
echo "      kubectl -n rook-ceph get secret rook-ceph-object-user-my-store-my-user -o jsonpath='{.data.AccessKey}' | base64 --decode"
echo "      kubectl -n rook-ceph get secret rook-ceph-object-user-my-store-my-user -o jsonpath='{.data.SecretKey}' | base64 --decode"
