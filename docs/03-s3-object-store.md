# S3 Object Store

## Overview
Ceph Object Store provides S3-compatible object storage via the RADOS Gateway (RGW).

## Features
- S3 API compatibility
- STS (Security Token Service) support
- Multi-tenancy
- Bucket lifecycle policies

## Deployment

### Automatic
The object store is deployed automatically with the cluster:
```bash
./scripts/02-deploy-cluster.sh
```

### Verify
```bash
./scripts/03-verify-s3.sh
```

## Configuration

### Pools
- **Metadata Pool**: Stores bucket/object metadata (replicated, size 2)
- **Data Pool**: Stores actual object data (replicated, size 2)

### Gateway
- **Instances**: 1 (increase for HA)
- **Port**: 80 (HTTP)
- **NodePort**: 30000 (external access)

## Usage

### Create User
```bash
kubectl apply -f - <<EOF
apiVersion: ceph.rook.io/v1
kind: CephObjectStoreUser
metadata:
  name: my-user
  namespace: rook-ceph
spec:
  store: my-store
  displayName: "My S3 User"
EOF
```

### Get Credentials
```bash
# Access Key
kubectl -n rook-ceph get secret rook-ceph-object-user-my-store-my-user \
  -o jsonpath='{.data.AccessKey}' | base64 --decode

# Secret Key
kubectl -n rook-ceph get secret rook-ceph-object-user-my-store-my-user \
  -o jsonpath='{.data.SecretKey}' | base64 --decode
```

### Test with AWS CLI
```bash
# Get endpoint
ENDPOINT="http://$(minikube ip):30000"

# Configure AWS CLI
aws configure set aws_access_key_id <ACCESS_KEY>
aws configure set aws_secret_access_key <SECRET_KEY>

# Create bucket
aws s3 mb s3://test-bucket --endpoint-url $ENDPOINT

# Upload file
echo "Hello Ceph" > test.txt
aws s3 cp test.txt s3://test-bucket/ --endpoint-url $ENDPOINT

# List objects
aws s3 ls s3://test-bucket/ --endpoint-url $ENDPOINT
```

### Test with Python (boto3)
```python
import boto3

s3 = boto3.client(
    's3',
    endpoint_url='http://<minikube-ip>:30000',
    aws_access_key_id='<ACCESS_KEY>',
    aws_secret_access_key='<SECRET_KEY>'
)

# Create bucket
s3.create_bucket(Bucket='my-bucket')

# Upload object
s3.put_object(Bucket='my-bucket', Key='hello.txt', Body=b'Hello Ceph!')

# List objects
response = s3.list_objects_v2(Bucket='my-bucket')
for obj in response.get('Contents', []):
    print(obj['Key'])
```

## STS (Temporary Credentials)

### AssumeRole Example
```python
import boto3

sts = boto3.client(
    'sts',
    endpoint_url='http://<minikube-ip>:30000',
    aws_access_key_id='<ACCESS_KEY>',
    aws_secret_access_key='<SECRET_KEY>'
)

# Get temporary credentials
response = sts.assume_role(
    RoleArn='arn:aws:iam:::role/my-role',
    RoleSessionName='my-session'
)

temp_creds = response['Credentials']
```

## Monitoring

### Check RGW Status
```bash
kubectl -n rook-ceph get pods -l app=rook-ceph-rgw
kubectl -n rook-ceph logs -l app=rook-ceph-rgw
```

### Check Object Store
```bash
kubectl -n rook-ceph get cephobjectstore
kubectl -n rook-ceph describe cephobjectstore my-store
```

## Troubleshooting

### RGW not starting
```bash
# Check events
kubectl -n rook-ceph describe cephobjectstore my-store

# Check logs
kubectl -n rook-ceph logs -l app=rook-ceph-rgw
```

### Connection refused
```bash
# Verify service
kubectl -n rook-ceph get svc rook-ceph-rgw-my-store-nodeport

# Test from within cluster
kubectl -n rook-ceph run -it --rm debug --image=curlimages/curl --restart=Never \
  -- curl http://rook-ceph-rgw-my-store.rook-ceph.svc.cluster.local
```

### Access denied
- Verify user credentials
- Check bucket policies
- Ensure user has correct permissions
