# PgBouncer

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) 

A Helm chart for deploying bitnami/pgbouncer with TLS encryption

**Homepage:** <https://github.com/one-acre-fund/oaf-private-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Rahma | <rahma.ahmed@oneacrefund.org> | <https://github.com/samaroon> |

## Source Code

* <https://github.com/one-acre-fund/oaf-private-charts>
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
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"bitnami/pgbouncer"` |  |
| image.tag | string | `"1.19.1-debian-11-r44"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `""` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls[0].hosts[0] | string | `""` |  |
| ingress.tls[0].secretName | string | `""` |  |
| nameOverride | string | `""` |  |
| pgbouncer.connectQuery | string | `""` |  |
| pgbouncer.database | string | `"${PGBOUNCER_DATABASE}"` |  |
| pgbouncer.host | string | `"postgresql"` |  |
| pgbouncer.password | string | `"your-postgresql-password"` |  |
| pgbouncer.port | int | `5432` |  |
| pgbouncer.setDatabasePassword | string | `"no"` |  |
| pgbouncer.setDatabaseUser | string | `"no"` |  |
| pgbouncer.username | string | `"postgres"` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| service.port | int | `6432` |  |
| service.type | string | `"ClusterIP"` |  |
| tls.certFile | string | `"tls.crt"` |  |
| tls.enabled | bool | `true` |  |
| tls.existingSecret | string | `"oaf-tls"` |  |
| tls.keyFile | string | `"tls.key"` |  |
