#!/bin/bash
set -e

echo "📦 Deploying Keycloak Instance..."

# Create namespaces
echo "Creating namespaces..."
kubectl create namespace keycloak --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace minio --dry-run=client -o yaml | kubectl apply -f -

# Deploy Keycloak instance
echo "Deploying Keycloak..."
helm upgrade --install keycloak \
  ./helm/keycloak \
  --namespace keycloak \
  --wait \
  --timeout 10m

echo ""
echo "✅ Keycloak deployment initiated"
echo ""
echo "Waiting for Keycloak to be ready..."
kubectl wait --for=condition=Ready pod -l app=keycloak -n keycloak --timeout=600s || true

echo ""
echo "Keycloak status:"
kubectl get keycloak -n keycloak
echo ""
kubectl get pods -n keycloak

echo ""
echo "Keycloak admin credentials:"
kubectl get secret keycloak-initial-admin -n keycloak -o jsonpath='{.data.username}' | base64 -d && echo ""
kubectl get secret keycloak-initial-admin -n keycloak -o jsonpath='{.data.password}' | base64 -d && echo ""

echo ""
echo "💡 Access Keycloak: kubectl port-forward -n keycloak svc/keycloak-service 8080:8080"
echo "💡 Next: Deploy MinIO with ./scripts/05-deploy-minio-operator.sh"
