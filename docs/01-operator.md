# Rook Operator Deployment

## Overview
The Rook Operator manages the lifecycle of Ceph clusters in Kubernetes. It watches for CephCluster custom resources and creates/manages the necessary Ceph components.

## Architecture
- **Operator Pod**: Runs in `rook-ceph` namespace
- **CRDs**: Defines custom resources (CephCluster, CephObjectStore, etc.)
- **RBAC**: Service accounts and permissions for cluster management

## Deployment

### Prerequisites
- Minikube cluster running (3 nodes recommended)
- Helm 3 installed
- kubectl configured

### Deploy
```bash
./scripts/01-deploy-operator.sh
```

### Verify
```bash
kubectl -n rook-ceph get pods
kubectl -n rook-ceph logs -l app=rook-ceph-operator
```

## Configuration

### Minimal Resources (Lab)
Located in `helm/rook/values-override.yaml`:
- CPU: 100m-500m
- Memory: 128Mi-256Mi

### Production
Increase resources in values-override.yaml:
```yaml
rook-ceph:
  resources:
    limits:
      cpu: 2000m
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 512Mi
```

## Troubleshooting

### Operator not starting
```bash
kubectl -n rook-ceph describe pod -l app=rook-ceph-operator
```

### CRDs not installed
```bash
kubectl get crds | grep ceph.rook.io
```

## Upgrade
```bash
# Update Chart.yaml version
helm upgrade rook helm/rook -f helm/rook/values-override.yaml -n rook-ceph
```
