# Data Platform on Minikube

Production-ready data platform with PostgreSQL, Keycloak, and SeaweedFS using Kubernetes operators.

## Quick Start

```bash
# 0. Start Minikube (profile: lakehouse)
./scripts/00-start-minikube.sh

# 1. Deploy PostgreSQL ✅ COMPLETED
./scripts/11-deploy-postgres-operator.sh
./scripts/12-deploy-postgres.sh

# 2. Deploy Keycloak (NEXT)
./scripts/21-deploy-keycloak-operator.sh
./scripts/22-deploy-keycloak.sh

# 3. Deploy SeaweedFS (TODO)
./scripts/31-deploy-seaweed.sh

# 4. Verify
kubectl get postgresql -n postgres
kubectl get keycloak -n keycloak
kubectl get pods -n seaweed
```

## Minikube Management

```bash
# Check status
./scripts/00-check-minikube.sh

# Delete cluster
./scripts/00-delete-minikube.sh

# Restart cluster
./scripts/00-delete-minikube.sh && ./scripts/00-start-minikube.sh
```

## Architecture

```
┌──────────────────────────────────────┐
│       Minikube Cluster               │
│                                      │
│  PostgreSQL (Zalando Operator)       │
│  ├─ keycloak-db                      │
│  └─ Job: postgres-init               │
│                                      │
│  Keycloak (Keycloak Operator)        │
│  ├─ Keycloak instance                │
│  ├─ Realm: datalake                  │
│  └─ Job: keycloak-config             │
│                                      │
│  SeaweedFS (Helm Chart)              │
│  ├─ Master + Volume + Filer          │
│  ├─ S3 API (port 8333)               │
│  ├─ Buckets: iceberg, lance          │
│  └─ Job: seaweed-create-buckets      │
└──────────────────────────────────────┘
```

## Components

| Component | Purpose | Deployment |\n|-----------|---------|------------|\n| PostgreSQL | Keycloak database | Zalando Postgres Operator |\n| Keycloak | SSO & RBAC | Keycloak Operator |\n| SeaweedFS | S3 object storage | Official Helm Chart |

## SeaweedFS Access

### S3 API
**Endpoint**: `http://seaweed-filer-s3.seaweed.svc:8333`  
**Access Key**: `admin`  
**Secret Key**: `admin`

### Web UIs
**Filer UI** (File Browser): Port 8888  
**Admin UI** (Cluster Management): Port 23646

**Access all UIs with one command:**
```bash
./scripts/32-access-seaweed-ui.sh
```

Then open:
- Filer UI: http://localhost:8888
- Admin UI: http://localhost:23646
- S3 API: http://localhost:8333

## Documentation

- [PostgreSQL Setup](docs/01-postgresql.md)
- [Keycloak Setup](docs/02-keycloak.md)
- [SeaweedFS Setup](docs/03-seaweedfs.md)
- [Verification Guide](docs/04-verification.md)

## Project Structure

```
.
├── helm/                    # Helm charts
│   ├── postgres-operator/
│   ├── postgres/
│   ├── keycloak-operator/
│   ├── keycloak/
│   └── seaweed/
├── scripts/                 # Deployment scripts
│   ├── 00-start-minikube.sh
│   ├── 00-check-minikube.sh
│   ├── 00-delete-minikube.sh
│   ├── 00-verify-kubectl.sh
│   ├── 00-verify-helm.sh
│   ├── 10-setup-postgres-chart.sh
│   ├── 11-deploy-postgres-operator.sh
│   ├── 12-deploy-postgres.sh
│   ├── 20-setup-keycloak-chart.sh
│   ├── 21-deploy-keycloak-operator.sh
│   ├── 22-deploy-keycloak.sh
│   ├── 30-setup-seaweed-chart.sh
│   ├── 31-deploy-seaweed.sh
│   └── cleanup.sh
├── docs/                    # Documentation
│   ├── 01-postgresql.md
│   ├── 02-keycloak.md
│   ├── 03-seaweedfs.md
│   └── 04-verification.md
├── claude-tasks.md         # Task tracking
└── README.md               # This file
```

## Cleanup

```bash
./scripts/cleanup.sh
```

## Requirements

- Minikube
- kubectl
- Helm 3
