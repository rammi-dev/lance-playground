#!/bin/bash
set -e

echo "🔧 Setting up Keycloak Helm chart..."

# Fetch upstream values.yaml from Bitnami
echo "Fetching upstream values.yaml from Bitnami..."
helm show values bitnami/keycloak --version 24.2.3 > ./helm/keycloak-operator/values.yaml

echo "✅ values.yaml fetched successfully"
echo ""
echo "📝 Chart structure:"
echo "  - values.yaml (upstream defaults)"
echo "  - values-override.yaml (your customizations)"
echo ""
echo "💡 Deploy with: ./scripts/21-deploy-keycloak-operator.sh"
