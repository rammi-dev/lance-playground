#!/bin/bash
set -e

echo "🔧 Setting up Postgres Operator Helm chart..."

# Add Helm repository
echo "Adding Postgres Operator Helm repository..."
helm repo add postgres-operator-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator 2>/dev/null || true
helm repo update

# Fetch upstream values.yaml
echo "Fetching upstream values.yaml..."
helm show values postgres-operator-charts/postgres-operator > ./helm/postgres-operator/values.yaml

echo "✅ values.yaml fetched successfully"
echo ""
echo "📝 Chart structure:"
echo "  - values.yaml (upstream defaults)"
echo "  - values-override.yaml (your customizations)"
echo ""
echo "💡 Deploy with: ./scripts/01-deploy-postgres-operator.sh"
