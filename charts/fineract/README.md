# fineract

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

Apache Fineract: A Platform for Microfinance

**Homepage:** <https://github.com/apache/fineract>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | yann.jouanique@gmail.com |  |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/fineract>

## TL;DR;

__NOTE__: Providing values for at least `mysql.auth.password` and `mysql.auth.rootPassword` is mandatory at installation time

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install --set mysql.auth.password=xxx --set mysql.auth.rootPassword=yyy my-release one-acre-fund/fineract
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mysql | ~8.4.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fineractServer.extraEnv | object | See `values.yaml` | Dictionary of key/value pairs to pass as environment variables to the backend pods They will be evaluated as Helm templates |
| fineractServer.extraSecretEnv | object | `{}` | Same as `extraEnv` but passed as secrets |
| fineractServer.image.name | string | `"apache/fineract"` | Fineract Docker image name |
| fineractServer.image.tag | string | `"latest"` | Fineract Docker image tag |
| fineractServer.replicas | int | `1` | Number of backend pods |
| fineractServer.resources | object | `{"limits":{"cpu":"1000m","memory":"1Gi"}}` | Resource settings for Backend pods |
| fineractUI.image.name | string | `"openmf/community-app"` | Frontend Docker image name |
| fineractUI.image.tag | string | `"latest"` | Frontend Docker image tag |
| fineractUI.replicas | int | `1` | Number of frontend pods |
| fineractUI.resources | object | `{"limits":{"cpu":"100m","memory":"100Mi"}}` | Resource settings for Backend pods |
| global.db.defaultDb | string | `"fineract_default"` | DB name for defaults db |
| global.db.tenantsDb | string | `"fineract_tenants"` | DB name for tenants db |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Create Ingress? |
| ingress.hosts | list | `[]` |  |
| ingress.tls | list | `[]` | TLS settings |
| mysql | object | see `values.yaml` | MySQL settings - see https://artifacthub.io/packages/helm/bitnami/mysql |
| mysql.auth.password | string | `""` | Please change these... |
| mysql.auth.rootPassword | string | `""` | Please change these... |
| mysql.auth.username | string | `"fineract"` | Fineract db user |
| mysql.enabled | bool | `true` | Install MySQL? |
| mysql.image.tag | string | `"5.7"` | _Warning_: Fineract db driver doesn't support mysql 8 |
| mysql.initdbScripts | object | see `values.yaml` | Dictionary of init scripts to run on initial MySQL setup __WARNING__! These db init scripts will only be executed on a brand new, uninitialized instance! Further changes will be ignored after the first init, unless you wipe the underlying PV/PVC volumes |
| service.type | string | `"ClusterIP"` | Service type for Fineract and UI services |