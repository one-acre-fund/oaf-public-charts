# metabase

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square)

Metabase with postgres persistence and plugins support

**Homepage:** <https://www.metabase.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | <yann.jouanique@gmail.com> |  |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/metabase>

## TL;DR;

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/metabase
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ~12.2.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| general.serviceType | string | `"ClusterIP"` | Used for all published services |
| global.storageClass | string | `"standard"` | This will be used on all pods for all PVCs, including dependencies (postgres) |
| ingress.annotations | object | `{}` | Dictionary of ingress annotations |
| ingress.domain | string | `"metabase.example.com"` | Host to use for ingress (required) |
| ingress.enabled | bool | `false` | Install ingress? |
| ingress.ingressClassName | string | `""` | ingressClassName of the ingress you want to use. Leave empty to use default |
| ingress.tls | list | `[]` | Ingress TLS settings, passed directly to ingress definition |
| javaOpts | string | `""` |  |
| metabase | object | see `values.yaml` | See https://www.metabase.com/docs/latest/operations-guide/running-metabase-on-docker.html for more details |
| metabase.extraPlugins | list | `[]` | Array of URLs to download extra plugins from (jar files) |
| metabase.image.name | string | `"metabase/metabase"` | Metabase image name |
| metabase.image.tag | string | `"latest"` | Metabase image tag |
| metabase.replicas | int | `1` | Replica count |
| postgresql | object | see `values.yaml` | Postgres config See https://artifacthub.io/packages/helm/bitnami/postgresql for docs |
| postgresql.auth.database | string | `"metabase"` | Database to create and use |
| postgresql.auth.password | string | `"ciJ8KfiMUK"` | Application password |
| postgresql.auth.postgresPassword | string | `"H55Djpc7Vs"` | Password for the `postgres` user |
| postgresql.auth.username | string | `"metabase"` | Application username |
| postgresql.enabled | bool | `true` | Install postgres? |
| postgresql.service.port | int | `5432` | Postgres port |
| resources | object | `{}` |  |