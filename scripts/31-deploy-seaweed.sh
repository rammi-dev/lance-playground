#!/bin/bash
set -e

echo "📦 Deploying SeaweedFS..."

# Setup chart (fetch upstream values)
echo "Setting up Helm chart..."
./scripts/30-setup-seaweed-chart.sh

# Build dependencies
echo "Building Helm dependencies..."
helm dependency build ./helm/seaweed

# Create namespace
echo "Creating namespace seaweed..."
kubectl create namespace seaweed --dry-run=client -o yaml | kubectl apply -f -

# Deploy SeaweedFS
echo "Deploying SeaweedFS..."
helm upgrade --install seaweed \
  ./helm/seaweed \
  --namespace seaweed \
  --values ./helm/seaweed/values-override.yaml \
  --wait \
  --timeout 10m

echo ""
echo "✅ SeaweedFS deployed successfully"
echo ""
echo "Verifying SeaweedFS pods..."
kubectl get pods -n seaweed

echo ""
echo "Waiting for all pods to be ready..."
kubectl wait --for=condition=Ready pod --all -n seaweed --timeout=300s || true

echo ""
echo "SeaweedFS services:"
kubectl get svc -n seaweed

echo ""
echo "📊 S3 API Access Information:"
echo "  Endpoint: http://seaweed-filer-s3.seaweed.svc:8333"
echo "  Access Key: admin"
echo "  Secret Key: admin"
echo ""
echo "💡 Port-forward to access S3 API locally:"
echo "  kubectl port-forward -n seaweed svc/seaweed-filer-s3 8333:8333"
echo ""
echo "💡 Test S3 access:"
echo "  export AWS_ACCESS_KEY_ID=admin"
echo "  export AWS_SECRET_ACCESS_KEY=admin"
echo "  aws s3 ls --endpoint-url http://localhost:8333"
