# geonode



![Version: 0.1.5](https://img.shields.io/badge/Version-0.1.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) 

Geonode - a CMS for Geospatial data

**Homepage:** <https://geonode.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | yann.jouanique@gmail.com |  |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/geonode>

## TL;DR;

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/geonode
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ~10.1.2 |
| https://charts.bitnami.com/bitnami | rabbitmq | ~8.6.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| general.debug | bool | `false` | activates various debug logs |
| general.externalDomain | string | `"example.com"` | Public domain used to access the application |
| general.externalPort | int | `443` | Public-facing port used to access the application |
| general.externalScheme | string | `"https"` | Public-facing protocol used to access the application |
| general.serviceType | string | `"ClusterIP"` | `ClusterIP` / `LoadBalancer` / `NodePort` |
| general.storageSize | string | `"10Gi"` | Volume storage size to request |
| general.superUser.email | string | `"support@example.com"` | Email address for `admin` user |
| general.superUser.password | string | `"geonode"` | Password for initial `admin` user - This user will have access to geonode UI but also the built-in Django admin interface (/admin) |
| general.supportEmail | string | `"support@example.com"` | Support email visible to users |
| geonode.extraConf | string | Some standard base layers | Configuration to append to `settings.py` Can be used to configure new base maps or any other setting from https://github.com/GeoNode/geonode/blob/master/geonode/settings.py For base maps available in MapStore, see https://github.com/geosolutions-it/MapStore2/blob/master/web/client/utils/ConfigProvider.js |
| geonode.extraConf2 | string | Some OAuth settings | Same as `extraConf` but can be overridden separately |
| geonode.extraEnvs | object | Various default values, see `values.yaml` | Use this to pass any env to `geonode` container See https://docs.geonode.org/en/master/basic/settings/index.html |
| geonode.extraSecretEnvs | object | `{}` | Same as `extraEnvs` but passed as a secret |
| geonode.image.name | string | `"geonode/geonode"` | Geonode image name |
| geonode.image.tag | string | `"3.1"` | Geonode image tag |
| geoserver.customEPSGs | list | Various useful ESPGs | List of custom ESPG definitions to add to Geoserver configuration - see https://docs.geoserver.org/stable/en/user/configuration/crshandling/customcrs.html |
| geoserver.extraCustomEPSGs | list | `[]` | Same as `customEPSGs` but can be overridden separately |
| geoserver.image.name | string | `"geonode/geoserver"` | `geoserver` image name |
| geoserver.image.tag | string | `"2.18.2"` | `geoserver` image tag |
| global.storageClass | string | `"standard"` | Will be used by this and all subcharts for all volumes |
| ingress.annotations | object | `{}` | Ingress annotations table |
| ingress.enabled | bool | `false` | Ingress enabled? |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths | list | `[]` |  |
| ingress.tls | list | `[]` | Ingress tls settings |
| postgresql.enabled | bool | `true` | Install Postgres? See See https://artifacthub.io/packages/helm/bitnami/postgresql for docs on all Postgres values |
| postgresql.geodataDb | string | `"geonode_data"` | Postgres database AND user name for geoserver |
| postgresql.geonodeDb | string | `"geonode"` | Postgres database AND user name for geonode |
| postgresql.initdbScriptsSecret | string | `"{{ .Release.Name }}-postgres-init"` | Name of secret containing Postgres init script - will only be run on first deployment! Will be evaluated as a template |
| postgresql.password | string | `"Uxu3UhxFmK"` | Application password for both geonodeDb and geodataDb users |
| postgresql.postgresqlPassword | string | `"admin"` |  |
| rabbitmq | object | `{"auth":{"erlangCookie":"jixYBsiZ9RivaLXC02pTwGjvIo0nHtVu","password":"3asgDlgwN7","username":"user"}}` | RbbitMQ Settings - see https://artifacthub.io/packages/helm/bitnami/rabbitmq |
| smtp.from | string | `nil` | SMTP "from" address |
| smtp.host | string | `"smtp.gmail.com"` | SMTP host name |
| smtp.password | string | `"changeme"` | SMTP password |
| smtp.port | string | `"587"` | SMTP port |
| smtp.tls | bool | `true` | Use TLS? |
| smtp.user | string | `nil` | SMTP user |