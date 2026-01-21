# Data Platform Deployment Tasks

## Stage 0: Prerequisites
- [x] Create Minikube start script (`scripts/00-start-minikube.sh`)
  - Profile: lakehouse
  - 3 nodes, 3 CPUs, 4GB RAM each
- [x] Create Minikube check script (`scripts/00-check-minikube.sh`)
- [x] Create Minikube delete script (`scripts/00-delete-minikube.sh`)
- [x] Verify Minikube scripts
- [x] Verify kubectl access (`scripts/00-verify-kubectl.sh`)
- [x] Verify Helm installed (`scripts/00-verify-helm.sh`)

## Stage 1: PostgreSQL (Zalando Operator)
- [x] Create `helm/postgres-operator` chart structure
- [x] Add Zalando operator as dependency
- [x] Create `helm/postgres` chart structure
- [x] Create PostgreSQL CR template (`postgresql.yaml`)
- [x] Create init Job template (`init-job.yaml`)
- [x] Create setup script (`scripts/10-setup-postgres-chart.sh`)
- [x] Create deployment script (`scripts/11-deploy-postgres-operator.sh`)
- [x] Create deployment script (`scripts/12-deploy-postgres.sh`)
- [x] Deploy Postgres Operator
- [x] Deploy PostgreSQL cluster
- [x] Verify PostgreSQL running
- [x] Verify init Job completed
- [x] Verify keycloak database created

## Stage 2: Keycloak (Keycloak Operator)
- [x] Create `helm/keycloak-operator` chart structure
- [x] Add Keycloak operator as dependency
- [x] Create `helm/keycloak` chart structure
- [x] Create Keycloak CR template (`keycloak.yaml`)
- [x] Create config Job template (`config-job.yaml`)
  - [x] Realm creation logic
  - [x] User creation logic (admin, datascientist)
  - [x] Role creation logic
- [x] Create setup script (`scripts/20-setup-keycloak-chart.sh`)
- [x] Create deployment script (`scripts/21-deploy-keycloak-operator.sh`)
- [x] Create deployment script (`scripts/22-deploy-keycloak.sh`)
- [ ] Clean up MinIO references from config-job.yaml
- [ ] Clean up MinIO client from values.yaml
- [ ] Deploy Keycloak Operator
- [ ] Deploy Keycloak instance
- [ ] Verify Keycloak running
- [ ] Verify config Job completed
- [ ] Verify realm exists
- [ ] Verify users exist

## Stage 3: SeaweedFS
- [ ] Create `helm/seaweed` chart structure
- [ ] Add SeaweedFS as dependency
- [ ] Create values-override.yaml
- [ ] Create buckets Job template (`buckets-job.yaml`)
- [ ] Create setup script (`scripts/30-setup-seaweed-chart.sh`)
- [ ] Create deployment script (`scripts/31-deploy-seaweed.sh`)
- [ ] Create UI access script (`scripts/32-access-seaweed-ui.sh`)
- [ ] Deploy SeaweedFS
- [ ] Verify SeaweedFS running
- [ ] Verify buckets Job completed
- [ ] Verify buckets exist (iceberg, lance)
- [ ] Test S3 API access
- [ ] Test Filer UI (port 8888)
- [ ] Test Admin UI (port 23646)

## Stage 4: Integration & Verification
- [ ] Access Keycloak admin console
- [ ] Access SeaweedFS S3 endpoint
- [ ] Test S3 operations:
  - [ ] Upload test file to iceberg bucket
  - [ ] Upload test file to lance bucket
  - [ ] Download test files
  - [ ] List buckets
- [ ] Create access documentation (`docs/04-verification.md`)
- [ ] Create cleanup script (`scripts/cleanup.sh`)

## Stage 5: Documentation
- [ ] Create PostgreSQL documentation (`docs/01-postgresql.md`)
- [ ] Create Keycloak documentation (`docs/02-keycloak.md`)
- [ ] Create SeaweedFS documentation (`docs/03-seaweedfs.md`)
- [ ] Create verification guide (`docs/04-verification.md`)
- [ ] Update README with quick start

---

## Progress Tracking

**Total Tasks:** 72
**Completed:** 26
**In Progress:** 2
**Remaining:** 44

**Current Stage:** Stage 2 - Keycloak (charts created, cleaning up MinIO references)

---

## Notes

- Mark tasks with `[x]` when completed
- Mark tasks with `[/]` when in progress
- Update progress tracking section as you go
