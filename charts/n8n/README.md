# n8n

![Version: 0.1.47](https://img.shields.io/badge/Version-0.1.47-informational?style=flat-square)

A Helm chart for n8n

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| bisonlou | <bisonlou@gmail.com> |  |
| Yann-J | <yann.jouanique@gmail.com> |  |

## TL;DR

[n8n](https://www.n8n.io/) is a fair-source API automation platform.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/n8n
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ~11.6.6 |
| https://charts.bitnami.com/bitnami | redis | ~17.7.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| communityNodes | list | `[]` | List of npm packages to install as community nodes |
| config | object | `{}` |  |
| defaults | string | `nil` |  |
| deploymentStrategy.type | string | `"Recreate"` |  |
| extraEnv | object | `{}` |  |
| extraSecretEnv | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"n8nio/n8n"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| master.command[0] | string | `"sh"` |  |
| master.command[1] | string | `"-c"` |  |
| master.command[2] | string | `"n8n"` |  |
| master.probes.livenessProbe.failureThreshold | int | `5` |  |
| master.probes.livenessProbe.httpGet.path | string | `"/healthz"` |  |
| master.probes.livenessProbe.httpGet.port | string | `"http"` |  |
| master.probes.livenessProbe.periodSeconds | int | `10` |  |
| master.probes.livenessProbe.successThreshold | int | `1` |  |
| master.probes.livenessProbe.timeoutSeconds | int | `2` |  |
| master.probes.readinessProbe.failureThreshold | int | `5` |  |
| master.probes.readinessProbe.httpGet.path | string | `"/healthz"` |  |
| master.probes.readinessProbe.httpGet.port | string | `"http"` |  |
| master.probes.readinessProbe.periodSeconds | int | `5` |  |
| master.probes.readinessProbe.successThreshold | int | `1` |  |
| master.probes.readinessProbe.timeoutSeconds | int | `2` |  |
| master.probes.startupProbe.failureThreshold | int | `30` |  |
| master.probes.startupProbe.httpGet.path | string | `"/healthz"` |  |
| master.probes.startupProbe.httpGet.port | string | `"http"` |  |
| master.probes.startupProbe.periodSeconds | int | `10` |  |
| master.probes.startupProbe.successThreshold | int | `1` |  |
| master.probes.startupProbe.timeoutSeconds | int | `2` |  |
| n8n.encryption_key | string | `nil` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.configMountPath | string | `"/n8n-config"` |  |
| persistence.enabled | bool | `false` |  |
| persistence.secretMountPath | string | `"/n8n-secret"` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.type | string | `"emptyDir"` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.persistence.size | string | `"200Gi"` |  |
| postgresql.postgresqlDatabase | string | `"n8n"` |  |
| postgresql.postgresqlPassword | string | `"changeme"` |  |
| postgresql.postgresqlPostgresPassword | string | `"changeme"` |  |
| postgresql.postgresqlUsername | string | `"n8n"` |  |
| redis.architecture | string | `"standalone"` |  |
| redis.auth.enabled | bool | `false` |  |
| redis.enabled | bool | `true` |  |
| redis.persistence.enabled | bool | `true` |  |
| redis.persistence.size | string | `"2Gi"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| secret | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.annotations | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| worker.command[0] | string | `"sh"` |  |
| worker.command[1] | string | `"-c"` |  |
| worker.command[2] | string | `"n8n worker"` |  |
