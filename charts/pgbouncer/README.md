# PgBouncer

![Version: 0.1.7](https://img.shields.io/badge/Version-0.1.7-informational?style=flat-square)
![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)
![AppVersion: 1.19.1](https://img.shields.io/badge/AppVersion-1.19.1-informational?style=flat-square)

A Helm chart for deploying bitnami/pgbouncer with TLS encryption

**Homepage:** <https://github.com/one-acre-fund/oaf-public-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Rahma | <rahma.ahmed@oneacrefund.org> | <https://github.com/samaroon> |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts>
* <https://bitnami.com/stack/pgbouncer>

## TL;DR

[pgbouncer](https://www.pgbouncer.org/) is a lightweight connection pooler for PostgreSQL.

```console
helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
helm install pgbouncer one-acre-fund/pgbouncer
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| extraConfigs | list | `[]` |  |
| extraSecretConfigs | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"bitnami/pgbouncer"` |  |
| image.tag | string | `"1.19.1-debian-11-r44"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| pgbouncer.connectQuery | string | `""` |  |
| pgbouncer.database | string | `"${PGBOUNCER_DATABASE}"` |  |
| pgbouncer.host | string | `"postgresql"` |  |
| pgbouncer.password | string | `"your-postgresql-password"` |  |
| pgbouncer.port | int | `5432` |  |
| pgbouncer.postgresqlDatabase | string | `"${PGBOUNCER_DATABASE}"` |  |
| pgbouncer.setDatabasePassword | string | `"no"` |  |
| pgbouncer.setDatabaseUser | string | `"no"` |  |
| pgbouncer.username | string | `"postgres"` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| service.port | int | `6432` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tls.certFilename | string | `"tls.crt"` |  |
| tls.certKeyFilename | string | `"tls.key"` |  |
| tls.certificatesSecret | string | `"oaf-tls"` |  |
| tls.enabled | bool | `true` |  |
