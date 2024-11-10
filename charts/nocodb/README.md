# nocodb



![Version: 0.4.1](https://img.shields.io/badge/Version-0.4.1-informational?style=flat-square) 

A Helm chart for Kubernetes



## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| samaroon | <rahma.ahmed@oneacrefund.org> | <https://github.com/samaroon> |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/nocodb>

## TL;DR

[nocodb](https://www.nocodb.com/) is an open source no-code platform to build and manage your data-driven applications.

```console
helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
helm install my-release one-acre-fund/nocodb
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://registry-1.docker.io/bitnamicharts | common | 2.x.x |
| oci://registry-1.docker.io/bitnamicharts | minio | 14.x.x |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 16.x.x |
| oci://registry-1.docker.io/bitnamicharts | redis | 20.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| admin.create | bool | `true` |  |
| admin.email | string | `""` |  |
| admin.existingSecret | string | `""` |  |
| admin.existingSecretEmailKey | string | `""` |  |
| admin.existingSecretPasswordKey | string | `""` |  |
| admin.password | string | `""` |  |
| affinity | object | `{}` |  |
| automountServiceAccountToken | bool | `false` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| commonAnnotations | object | `{}` |  |
| commonLabels | object | `{}` |  |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| containerSecurityContext.capabilities.add[0] | string | `"CHOWN"` |  |
| containerSecurityContext.capabilities.add[1] | string | `"FOWNER"` |  |
| containerSecurityContext.capabilities.add[2] | string | `"SYS_CHROOT"` |  |
| containerSecurityContext.capabilities.add[3] | string | `"SETGID"` |  |
| containerSecurityContext.capabilities.add[4] | string | `"SETUID"` |  |
| containerSecurityContext.capabilities.add[5] | string | `"DAC_OVERRIDE"` |  |
| containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| containerSecurityContext.enabled | bool | `true` |  |
| containerSecurityContext.privileged | bool | `false` |  |
| containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| containerSecurityContext.runAsGroup | int | `0` |  |
| containerSecurityContext.runAsNonRoot | bool | `false` |  |
| containerSecurityContext.runAsUser | int | `0` |  |
| containerSecurityContext.seLinuxOptions | object | `{}` |  |
| containerSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| externalDatabase.create | bool | `true` |  |
| externalDatabase.database | string | `"nocodb"` |  |
| externalDatabase.existingSecret | string | `""` |  |
| externalDatabase.existingSecretPasswordKey | string | `""` |  |
| externalDatabase.existingSecretPostgresPasswordKey | string | `""` |  |
| externalDatabase.host | string | `""` |  |
| externalDatabase.password | string | `""` |  |
| externalDatabase.port | int | `5432` |  |
| externalDatabase.postgresqlPostgresPassword | string | `""` |  |
| externalDatabase.postgresqlPostgresUser | string | `"postgres"` |  |
| externalDatabase.user | string | `"nocodb_user"` |  |
| externalMinio.bucketName | string | `""` |  |
| externalMinio.create | bool | `true` |  |
| externalMinio.endpoint | string | `""` |  |
| externalMinio.existingSecret | string | `""` |  |
| externalMinio.region | string | `"us-east-1"` |  |
| externalMinio.rootPassword | string | `""` |  |
| externalMinio.rootPasswordSecretKey | string | `""` |  |
| externalMinio.rootUser | string | `"admin"` |  |
| externalMinio.rootUserSecretKey | string | `""` |  |
| extraEnv | list | `[]` |  |
| extraEnvSecrets | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.defaultStorageClass | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.imageRegistry | string | `""` |  |
| global.storageClass | string | `""` |  |
| hostAliases | list | `[]` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nocodb/nocodb"` |  |
| image.tag | string | `"0.257.2"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/api/v1/health"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| livenessProbe.initialDelaySeconds | int | `60` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| minio.auth.existingSecret | string | `""` |  |
| minio.auth.rootPassword | string | `""` |  |
| minio.auth.rootPasswordSecretKey | string | `""` |  |
| minio.auth.rootUser | string | `"admin"` |  |
| minio.auth.rootUserSecretKey | string | `""` |  |
| minio.defaultBuckets | string | `"nocodb"` |  |
| minio.enabled | bool | `false` |  |
| minio.region | string | `"us-east-1"` |  |
| nameOverride | string | `""` |  |
| nocodb.backendUrl | string | `""` |  |
| nocodb.publicUrl | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.enabled | bool | `true` |  |
| podSecurityContext.fsGroup | int | `0` |  |
| podSecurityContext.fsGroupChangePolicy | string | `"Always"` |  |
| podSecurityContext.supplementalGroups | list | `[]` |  |
| podSecurityContext.sysctls | list | `[]` |  |
| postgresql.architecture | string | `"standalone"` |  |
| postgresql.auth.database | string | `"nocodb"` |  |
| postgresql.auth.enablePostgresUser | bool | `true` |  |
| postgresql.auth.existingSecret | string | `""` |  |
| postgresql.auth.password | string | `""` |  |
| postgresql.auth.postgresPassword | string | `""` |  |
| postgresql.auth.replicationPassword | string | `""` |  |
| postgresql.auth.username | string | `"nocodb_user"` |  |
| postgresql.enabled | bool | `false` |  |
| priorityClassName | string | `""` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.httpGet.path | string | `"/api/v1/health"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| readinessProbe.initialDelaySeconds | int | `30` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
| redis.auth.password | string | `""` |  |
| redis.enabled | bool | `false` |  |
| redis.master.disableCommands[0] | string | `"FLUSHALL"` |  |
| redis.replica.disableCommands[0] | string | `"FLUSHALL"` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"500m"` |  |
| resources.limits.ephemeral-storage | string | `"2Gi"` |  |
| resources.limits.memory | string | `"1Gi"` |  |
| resources.requests.cpu | string | `"250m"` |  |
| resources.requests.ephemeral-storage | string | `"1Gi"` |  |
| resources.requests.memory | string | `"512Mi"` |  |
| schedulerName | string | `""` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | string | `""` |  |
| service.externalTrafficPolicy | string | `"Cluster"` |  |
| service.extraPorts | list | `[]` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.nodePorts.http | string | `""` |  |
| service.ports.http | int | `8080` |  |
| service.sessionAffinity | string | `"None"` |  |
| service.sessionAffinityConfig | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| smtp.domain | string | `""` |  |
| smtp.enabled | bool | `false` |  |
| smtp.existingSecret | string | `""` |  |
| smtp.existingSecretPasswordKey | string | `""` |  |
| smtp.existingSecretUsernameKey | string | `""` |  |
| smtp.from | string | `""` |  |
| smtp.host | string | `"smtp.gmail.com"` |  |
| smtp.ignoreTLS | bool | `true` |  |
| smtp.password | string | `""` |  |
| smtp.port | int | `465` |  |
| smtp.rejectUnauthorized | bool | `true` |  |
| smtp.secure | bool | `true` |  |
| smtp.username | string | `""` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |
