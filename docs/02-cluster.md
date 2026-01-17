# Ceph Cluster Deployment

## Overview
The Ceph cluster provides distributed storage with Mon (monitors), Mgr (managers), and OSD (object storage daemons) components.

## Architecture

### Components
- **Mon (Monitor)**: Cluster state and quorum (1 for lab, 3+ for production)
- **Mgr (Manager)**: Metrics, dashboard, orchestration (1-2 instances)
- **OSD (Object Storage Daemon)**: Actual data storage (1 per node/disk)

### Storage Backend
For Minikube, we use **directory-based OSDs**:
- Path: `/var/lib/rook-storage` on each node
- Simpler than device management
- Good for testing/lab environments

## Deployment

### Prerequisites
- Rook Operator deployed and running
- Sufficient resources (4-5GB RAM, 2-3 CPUs)

### Deploy
```bash
./scripts/02-deploy-cluster.sh
```

### Monitor Progress
```bash
# Watch pods being created
kubectl -n rook-ceph get pods -w

# Check cluster status
kubectl -n rook-ceph get cephcluster
```

## Configuration

### Minimal Lab Setup
Located in `helm/ceph-cluster/templates/ceph-cluster.yaml`:
- 1 Mon (minimal quorum)
- 1 Mgr
- OSDs on all nodes
- Resource limits applied

### Production Recommendations
- 3+ Mons (odd number for quorum)
- 2 Mgrs (high availability)
- Device-based OSDs (dedicated disks)
- Increase resource limits

## Verification

### Check Health
```bash
# Cluster status
kubectl -n rook-ceph get cephcluster

# Expected: HEALTH_OK, phase: Ready
```

### Access Dashboard
```bash
# Get dashboard password
kubectl -n rook-ceph get secret rook-ceph-dashboard-password \
  -o jsonpath="{['data']['password']}" | base64 --decode

# Port forward
kubectl -n rook-ceph port-forward svc/rook-ceph-mgr-dashboard 8443:8443

# Access: https://localhost:8443
# Username: admin
```

## Troubleshooting

### Pods stuck in Pending
```bash
# Check events
kubectl -n rook-ceph get events --sort-by='.lastTimestamp'

# Check node resources
kubectl top nodes
```

### OSDs not starting
```bash
# Check OSD prepare logs
kubectl -n rook-ceph logs -l app=rook-ceph-osd-prepare

# Verify storage path exists on nodes
minikube ssh
ls -la /var/lib/rook-storage
```

### Cluster not reaching HEALTH_OK
```bash
# Check Ceph status
kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph status
kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph osd tree
```
