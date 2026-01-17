# Rook Ceph on Minikube

Complete deployment guide for Rook Ceph with S3 object storage on Minikube.

## Quick Start

```bash
# 1. Start Minikube
bash start.sh

# 2. Deploy Rook Operator
./scripts/01-deploy-operator.sh

# 3. Deploy Ceph Cluster + S3
./scripts/02-deploy-cluster.sh

# 4. Verify S3
./scripts/03-verify-s3.sh
```

## Architecture

```
┌─────────────────────────────────────────┐
│         Minikube (3 nodes)              │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │   Namespace: rook-ceph            │  │
│  │                                   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  Rook Operator              │  │  │
│  │  │  (helm/rook)                │  │  │
│  │  └─────────────────────────────┘  │  │
│  │                                   │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  Ceph Cluster               │  │  │
│  │  │  (helm/ceph-cluster)        │  │  │
│  │  │                             │  │  │
│  │  │  - Mon (1)                  │  │  │
│  │  │  - Mgr (1)                  │  │  │
│  │  │  - OSD (3)                  │  │  │
│  │  │  - RGW (S3) (1)             │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
         │
         │ NodePort 30000
         ▼
    S3 API Access
```

## Project Structure

```
.
├── helm/
│   ├── rook/                    # Rook Operator chart
│   │   ├── Chart.yaml
│   │   ├── values.yaml          # Upstream defaults
│   │   └── values-override.yaml # Lab configuration
│   └── ceph-cluster/            # Ceph Cluster chart
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── ceph-cluster.yaml
│           └── ceph-object-store.yaml
├── scripts/
│   ├── 01-deploy-operator.sh   # Deploy operator
│   ├── 02-deploy-cluster.sh    # Deploy cluster
│   ├── 03-verify-s3.sh         # Verify S3
│   └── cleanup.sh              # Cleanup all
├── docs/
│   ├── 01-operator.md          # Operator guide
│   ├── 02-cluster.md           # Cluster guide
│   └── 03-s3-object-store.md   # S3 guide
├── start.sh                    # Minikube startup
└── README.md                   # This file
```

## Documentation

- [Operator Deployment](docs/01-operator.md)
- [Cluster Deployment](docs/02-cluster.md)
- [S3 Object Store](docs/03-s3-object-store.md)

## Resource Requirements

**Minimal Lab:**
- 3 nodes
- 6GB RAM per node
- 4 CPUs per node
- Total: ~18GB RAM, 12 CPUs

**Actual Usage:**
- Operator: ~100-200MB RAM
- Mon: ~256-512MB RAM
- Mgr: ~256-512MB RAM
- OSD: ~1-2GB RAM each
- RGW: ~256-512MB RAM

## Cleanup

```bash
./scripts/cleanup.sh
```

## Troubleshooting

### Common Issues

1. **Pods stuck in Pending**
   - Check node resources: `kubectl top nodes`
   - Check events: `kubectl -n rook-ceph get events`

2. **Cluster not healthy**
   - Check logs: `kubectl -n rook-ceph logs -l app=rook-ceph-operator`
   - Check Ceph status: `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph status`

3. **S3 connection refused**
   - Verify RGW pods: `kubectl -n rook-ceph get pods -l app=rook-ceph-rgw`
   - Check service: `kubectl -n rook-ceph get svc`

## Next Steps

1. Create S3 users
2. Configure bucket policies
3. Integrate with applications
4. Set up monitoring (Prometheus/Grafana)
5. Configure backups

## References

- [Rook Documentation](https://rook.io/docs/rook/latest/)
- [Ceph Documentation](https://docs.ceph.com/)
- [S3 API Reference](https://docs.aws.amazon.com/AmazonS3/latest/API/)
