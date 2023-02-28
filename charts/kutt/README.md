# kutt

![Version: 0.2.5](https://img.shields.io/badge/Version-0.2.5-informational?style=flat-square)

A Helm chart for Kubernetes

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| bisonlou | <bisonlou@gmail.com> |  |

## TL;DR

[Kutt](https://github.com/thedevs-network/kutt) is an open-source URL Shortening service.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/kutt
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| <https://charts.bitnami.com/bitnami> | postgresql | ~12.1.2 |
| <https://charts.bitnami.com/bitnami> | redis | ~17.3.11 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env.ADMIN_EMAILS | string | `"admin@gmail.com"` |  |
| env.CONTACT_EMAIL | string | `"admin@gmail.com"` |  |
| env.CUSTOM_DOMAIN_USE_HTTPS | bool | `false` |  |
| env.DB_HOST | string | `"kutt-postgresql"` |  |
| env.DB_NAME | string | `"redis"` |  |
| env.DB_USER | string | `"postgres"` |  |
| env.DEFAULT_DOMAIN | string | `"local"` |  |
| env.DEFAULT_MAX_STATS_PER_LINK | int | `5000` |  |
| env.DISALLOW_ANONYMOUS_LINKS | bool | `false` |  |
| env.DISALLOW_REGISTRATION | bool | `false` |  |
| env.LINK_LENGTH | int | `6` |  |
| env.MAIL_FROM | string | `"admin@gmail.com"` |  |
| env.MAIL_HOST | string | `"smtp.gmail.com"` |  |
| env.MAIL_PORT | string | `"865"` |  |
| env.MAIL_SECURE | string | `"true"` |  |
| env.REDIS_HOST | string | `"kutt-redis-master"` |  |
| env.REPORT_EMAIL | string | `"admin@gmail.com"` |  |
| env.SENTRY_PRIVATE_DSN | string | `"https://sentry/dsn"` |  |
| env.SENTRY_PUBLIC_DSN | string | `"https://sentry/dsn"` |  |
| env.SITE_NAME | string | `"kutt"` |  |
| env.USER_LIMIT_PER_DAY | int | `50` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"kutt/kutt"` |  |
| image.tag | string | `"latest"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgresql.enabled | bool | `false` |  |
| postgresql.existingSecret | string | `"kutt-postgresql"` |  |
| postgresql.postgresqlDatabase | string | `"kutt"` |  |
| postgresql.postgresqlUsername | string | `"postgres"` |  |
| redis.enabled | bool | `false` |  |
| redis.existingSecret | string | `"redis"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| secretEnv.JWT_SECRET | string | `"verysecret"` |  |
| secretEnv.MAIL_PASSWORD | string | `"mailpassword"` |  |
| secretEnv.MAIL_USER | string | `"admin@mail.com"` |  |
| securityContext | object | `{}` |  |
| service.port | int | `10195` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
