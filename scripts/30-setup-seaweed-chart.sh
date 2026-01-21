#!/bin/bash
set -e

echo "📦 Setting up SeaweedFS Helm chart..."

# Add SeaweedFS Helm repository
echo "Adding SeaweedFS repository..."
helm repo add seaweedfs https://seaweedfs.github.io/seaweedfs/helm
helm repo update

# Fetch upstream values
echo "Fetching upstream values..."
helm show values seaweedfs/seaweedfs > ./helm/seaweed/values.yaml

echo ""
echo "✅ SeaweedFS chart setup complete"
echo ""
echo "📄 Upstream values saved to: helm/seaweed/values.yaml"
echo "💡 Review and customize values-override.yaml as needed"
