#!/bin/bash
set -e

echo "📦 Deploying Zalando Postgres Operator..."

# Setup chart (fetch upstream values)
echo "Setting up Helm chart..."
./scripts/10-setup-postgres-chart.sh

# Build dependencies
echo "Building Helm dependencies..."
helm dependency build ./helm/postgres-operator

# Create namespace
echo "Creating namespace postgres-operator..."
kubectl create namespace postgres-operator --dry-run=client -o yaml | kubectl apply -f -

# Deploy operator
echo "Deploying Postgres Operator..."
helm upgrade --install postgres-operator \
  ./helm/postgres-operator \
  --namespace postgres-operator \
  --values ./helm/postgres-operator/values-override.yaml \
  --wait \
  --timeout 5m

echo ""
echo "✅ Postgres Operator deployed successfully"
echo ""
echo "Verifying operator pod..."
kubectl get pods -n postgres-operator

echo ""
echo "💡 Next: Deploy PostgreSQL cluster with ./scripts/12-deploy-postgres.sh"
