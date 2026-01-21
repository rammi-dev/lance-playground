#!/bin/bash
set -e

echo "📦 Deploying Keycloak Operator..."

# Setup chart (fetch upstream values)
echo "Setting up Helm chart..."
./scripts/20-setup-keycloak-chart.sh

# Build dependencies
echo "Building Helm dependencies..."
helm dependency build ./helm/keycloak-operator

# Create namespace
echo "Creating namespace keycloak-operator..."
kubectl create namespace keycloak-operator --dry-run=client -o yaml | kubectl apply -f -

# Deploy operator
echo "Deploying Keycloak Operator..."
helm upgrade --install keycloak-operator \
  ./helm/keycloak-operator \
  --namespace keycloak-operator \
  --values ./helm/keycloak-operator/values-override.yaml \
  --wait \
  --timeout 5m

echo ""
echo "✅ Keycloak Operator deployed successfully"
echo ""
echo "Verifying operator pod..."
kubectl get pods -n keycloak-operator

echo ""
echo "💡 Next: Deploy Keycloak instance with ./scripts/22-deploy-keycloak.sh"
