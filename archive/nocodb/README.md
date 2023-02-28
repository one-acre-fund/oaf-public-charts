# nocodb

![Version: 0.2.10](https://img.shields.io/badge/Version-0.2.10-informational?style=flat-square)

A Helm chart for Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| bisonlou | <bisonlou@gmail.com> |  |

## TL;DR

[Nocodb](https://www.nocodb.com/) is an open-source smart spreadsheet / low-code solution.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/nocodb
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ~11.6.6 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env.postgresqlDatabase | string | `"root_db"` |  |
| env.postgresqlPassword | string | `"secretPass"` |  |
| env.postgresqlUsername | string | `"postgres"` |  |
| extraEnvs.NC_PUBLIC_URL | string | `"https:/nocodb.local.org"` |  |
| extraSecretEnvs.NC_AUTH_JWT_SECRET | string | `"secretString"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"nocodb/nocodb"` |  |
| image.tag | string | `"latest"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| keel.images[0].repository | string | `"image.repository"` |  |
| keel.images[0].tag | string | `"image.tag"` |  |
| keel.policy | string | `"all"` |  |
| keel.pollSchedule | string | `"@every 60m"` |  |
| keel.trigger | string | `"poll"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.persistence.size | string | `"8Gi"` |  |
| postgresql.postgresqlDatabase | string | `"nocodb"` |  |
| postgresql.postgresqlPassword | string | `"changeme"` |  |
| postgresql.postgresqlPostgresPassword | string | `"changeme"` |  |
| postgresql.postgresqlUsername | string | `"postgres"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| storage.size | string | `"3Gi"` |  |
| storage.storageClassName | string | `"oaf-shared"` |  |
| tolerations | list | `[]` |  |
