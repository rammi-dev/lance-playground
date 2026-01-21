#!/bin/bash
set -e

echo "📦 Deploying PostgreSQL Cluster..."

# Create namespace
echo "Creating namespace postgres..."
kubectl create namespace postgres --dry-run=client -o yaml | kubectl apply -f -

# Deploy PostgreSQL cluster
echo "Deploying PostgreSQL cluster..."
helm upgrade --install postgres \
  ./helm/postgres \
  --namespace postgres \
  --wait \
  --timeout 5m

echo ""
echo "✅ PostgreSQL cluster deployment initiated"
echo ""
echo "Waiting for PostgreSQL to be ready..."
kubectl wait --for=condition=Ready pod -l cluster-name=keycloak-db -n postgres --timeout=300s || true

echo ""
echo "PostgreSQL cluster status:"
kubectl get postgresql -n postgres
echo ""
kubectl get pods -n postgres

echo ""
echo "💡 PostgreSQL credentials are in secret: keycloak.keycloak-db.credentials.postgresql.acid.zalan.do"
echo "💡 Next: Deploy Keycloak with ./scripts/21-deploy-keycloak-operator.sh"
