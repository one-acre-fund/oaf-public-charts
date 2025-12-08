# OAF Odoo Data Migration Helm Chart

This Helm chart deploys the OAF Odoo Data Migration application to a Kubernetes cluster using an embedded data approach for large Excel files.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Access to an Odoo instance
- Azure Container Registry access (or local Docker image)
- **Minimum 4Gi memory** for large Excel file processing

## Quick Installation

### Using the Deploy Script (Recommended)

The fastest way to deploy is using the included script:

```bash
# Development deployment
./deploy.sh deploy dev

# Production deployment  
./deploy.sh deploy prod
```

The script automatically:
- Detects large data files (>3MB) and builds embedded Docker images
- Configures environment-specific settings
- Handles registry authentication
- Shows deployment status

### Manual Installation

```bash
# Install with development values
helm install oaf-migration ./helm-chart -f values-development.yaml

# Install with production values
helm install oaf-migration ./helm-chart -f values-production.yaml
```

## Configuration

The following table lists the configurable parameters and their current defaults.

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Container image repository | `oaftech.azurecr.io/oneacrefund/oaf-odoo-data-migration` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `imagePullSecrets` | Registry authentication secrets | `[]` |

### Odoo Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `odoo.url` | Odoo server URL (web interface) | `""` |
| `odoo.database` | Odoo database name | `""` |
| `odoo.username` | Odoo username | `""` |
| `odoo.password` | Odoo password | `""` |
| `odoo.useSecret` | Use Kubernetes secrets for credentials | `false` (dev), `true` (prod) |

### Job Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `job.enabled` | Enable one-time job execution | `true` (dev), `false` (prod) |
| `job.restartPolicy` | Job restart policy | `Never` |
| `job.backoffLimit` | Job backoff limit | `3` |
| `job.activeDeadlineSeconds` | Job timeout in seconds | `3600` |
| `job.ttlSecondsAfterFinished` | TTL after job completion | `7200` (dev), `86400` (prod) |

### CronJob Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `cronJob.enabled` | Enable scheduled job execution | `false` (dev), `true` (prod) |
| `cronJob.schedule` | Cron schedule expression | `"0 3 * * 1"` (Monday 3 AM) |
| `cronJob.suspend` | Suspend cron job execution | `false` |
| `cronJob.successfulJobsHistoryLimit` | Keep successful job history | `5` |
| `cronJob.failedJobsHistoryLimit` | Keep failed job history | `3` |

### Resource Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `resources.limits.cpu` | CPU limit | `1000m` (dev), `4000m` (prod) |
| `resources.limits.memory` | **Memory limit (critical for large files)** | `4Gi` (dev), `8Gi` (prod) |
| `resources.requests.cpu` | CPU request | `200m` (dev), `2000m` (prod) |
| `resources.requests.memory` | Memory request | `512Mi` (dev), `4Gi` (prod) |

### Data Storage Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistent storage | `false` (embedded data approach) |
| `dataFiles.configMapName` | ConfigMap for small data files | `""` (disabled for large files) |
| `dataFiles.mountPath` | Data mount path in container | `"/app/data"` |

## Usage Examples

### 1. Development Deployment (Recommended)

```bash
# Using the deploy script (handles everything automatically)
./deploy.sh deploy dev

# Or manually with Helm
helm install oaf-migration ./helm-chart -f values-development.yaml \
  --set odoo.url="https://sales.uat.oneacrefund.org/" \
  --set odoo.database="bitnami_odoo" \
  --set odoo.username="oafadmin" \
  --set-string odoo.password="your-password"
```

### 2. Production Deployment with Secrets

```bash
# Create Odoo credentials secret first
kubectl create secret generic odoo-credentials \
  --from-literal=url="https://odoo.yourcompany.com" \
  --from-literal=database="production_db" \
  --from-literal=username="migration_user" \
  --from-literal=password="secure-password"

# Deploy with production values
./deploy.sh deploy prod

# Or manually
helm install oaf-migration ./helm-chart -f values-production.yaml
```

### 3. Azure Container Registry Authentication

```bash
# Create ACR authentication secret
kubectl create secret docker-registry acr-secret \
  --docker-server=oaftech.azurecr.io \
  --docker-username=your-acr-username \
  --docker-password=your-acr-password

# Update values to use the secret
helm install oaf-migration ./helm-chart -f values-production.yaml \
  --set imagePullSecrets[0].name=acr-secret
```

### 4. Large File Handling

This chart uses an **embedded data approach** for large Excel files:

```bash
# The deploy script automatically detects large files (>3MB)
# and builds a Docker image with embedded data
ls -lh data/partners.xlsx  # Check your file size

# For 46MB file, it will automatically:
# 1. Build image with embedded data
# 2. Set memory limits to 4Gi+
# 3. Skip ConfigMap creation
./deploy.sh deploy dev
```

## Monitoring and Troubleshooting

### Check Deployment Status

```bash
# Quick status check (includes jobs, pods, configmaps)
./deploy.sh status

# Manual monitoring
kubectl get jobs -l "app.kubernetes.io/name=oaf-odoo-data-migration"
kubectl get pods -l "app.kubernetes.io/name=oaf-odoo-data-migration"
```

### View Logs

```bash
# Follow logs in real-time
./deploy.sh logs

# Manual log viewing
kubectl logs -f -l "app.kubernetes.io/name=oaf-odoo-data-migration"

# Logs for specific job
kubectl logs job/oaf-migration
```

### Common Issues and Solutions

#### 1. OOMKilled Errors
```bash
# Symptom: Pods fail with OOMKilled status
kubectl get pods  # Shows OOMKilled

# Solution: Increase memory limits
# Large Excel files (40MB+) need 4-8Gi memory
# Already configured in values-development.yaml (4Gi)
```

#### 2. ImagePullBackOff
```bash
# Symptom: Cannot pull image from ACR
kubectl describe pod <pod-name>

# Solution: Create image pull secret
kubectl create secret docker-registry acr-secret \
  --docker-server=oaftech.azurecr.io \
  --docker-username=$ACR_USERNAME \
  --docker-password=$ACR_PASSWORD
```

#### 3. Authentication Failed
```bash
# Check Odoo connection settings
kubectl logs <pod-name> | grep -i auth

# Verify credentials and URL format
# URL should be: https://sales.uat.oneacrefund.org/ (with trailing slash)
```

#### 4. Data File Not Found
```bash
# Check embedded data in image
kubectl exec -it <pod-name> -- ls -la /app/data/

# For ConfigMap approach (small files only)
kubectl get configmap oaf-migration-data -o yaml
```

### Performance Monitoring

```bash
# Monitor resource usage during job execution
kubectl top pods -l "app.kubernetes.io/name=oaf-odoo-data-migration"

# Watch job progress in real-time
kubectl logs -f <pod-name> | grep "Progress:"
```

## Security Configuration

### 1. Production Secrets Management

```bash
# Create comprehensive secrets for production
kubectl create secret generic oaf-migration-secrets \
  --from-literal=odoo-url="https://odoo.yourcompany.com" \
  --from-literal=odoo-database="production_db" \
  --from-literal=odoo-username="migration_user" \
  --from-literal=odoo-password="your-secure-password"

# Chart automatically uses secrets when useSecret: true (production default)
```

### 2. Azure Container Registry Access

```bash
# Method 1: Create pull secret
kubectl create secret docker-registry oaftech-acr \
  --docker-server=oaftech.azurecr.io \
  --docker-username=$ACR_USERNAME \
  --docker-password=$ACR_PASSWORD

# Method 2: Service Principal authentication
az acr login --name oaftech
```

### 3. Security Context (Production)

The production configuration includes:
- `runAsNonRoot: true`
- `runAsUser: 1000`
- `readOnlyRootFilesystem: true`
- Dropped capabilities: `ALL`

### 4. Network Policies (Optional)

Consider implementing network policies to restrict pod-to-pod communication:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: oaf-migration-netpol
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: oaf-odoo-data-migration
  policyTypes:
  - Egress
  egress:
  - to: []  # Allow all egress (for Odoo API calls)
```

## Architecture and Design

### Data Handling Strategy

This chart uses an **embedded data approach** instead of traditional ConfigMaps or persistent volumes:

**Why Embedded Data?**
- ✅ **Large File Support**: No 1MB ConfigMap size limit
- ✅ **Simplified Deployment**: No external dependencies
- ✅ **Immutable Data**: Data versioned with application
- ✅ **Better Performance**: No volume mounting overhead

**How It Works:**
1. `deploy.sh` detects files >3MB automatically
2. Builds Docker image with `COPY data/ /app/data/`
3. Application reads from `/app/data/partners.xlsx`
4. Job completes and cleans up

### Memory Requirements

**Critical:** Large Excel files require significant memory:
- **46MB Excel file** → **4-8Gi memory needed**
- Memory usage pattern: 2-4x file size during openpyxl processing
- Development: 4Gi limit configured
- Production: 8Gi limit configured

### Job vs CronJob Pattern

**Development (values-development.yaml):**
- `job.enabled: true` - One-time execution for testing
- `cronJob.enabled: false`
- Extended TTL (2 hours) for debugging

**Production (values-production.yaml):**
- `job.enabled: false` 
- `cronJob.enabled: true` - Scheduled execution (Monday 3 AM)
- Shorter TTL (24 hours) for cleanup

## Uninstalling

```bash
# Using deploy script
./deploy.sh cleanup

# Manual cleanup
helm uninstall oaf-migration
kubectl delete configmap oaf-migration-data  # If used
kubectl delete secret oaf-migration-secrets  # If created
```

**Note:** PersistentVolumeClaims are not created in this chart (embedded data approach), so no manual PVC cleanup needed.

## Development and Contributing

### Local Testing

```bash
# Lint the chart
helm lint ./helm-chart

# Generate templates for inspection
helm template test-release ./helm-chart -f values-development.yaml

# Dry-run installation
helm install test-release ./helm-chart -f values-development.yaml --dry-run

# Local development with deploy script
./deploy.sh build  # Build image only
./deploy.sh deploy dev  # Full deployment
```

### Chart Validation

```bash
# Test with different values files
helm template ./helm-chart -f values-development.yaml > dev-output.yaml
helm template ./helm-chart -f values-production.yaml > prod-output.yaml

# Validate generated Kubernetes manifests
kubectl apply --dry-run=client -f dev-output.yaml
```

### Adding New Features

1. Update templates in `helm-chart/templates/`
2. Add configuration to `values.yaml` and environment-specific files
3. Update this README with new parameters
4. Test with both development and production values
5. Update `deploy.sh` if automation changes needed

## Support and Documentation

- **Deploy Script Help**: `./deploy.sh help`
- **Helm Chart Values**: See `values-development.yaml` and `values-production.yaml`
- **Application Logs**: Use `./deploy.sh logs` for real-time monitoring
- **Status Monitoring**: Use `./deploy.sh status` for deployment overview
