# kobotoolbox

![Version: 0.7.4](https://img.shields.io/badge/Version-0.7.4-informational?style=flat-square)

KoboToolbox field data collection solution

**Homepage:** <https://www.kobotoolbox.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | <yann.jouanique@gmail.com> |  |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/kobotoolbox>

## TL;DR;

[KoboToolbox](https://www.kobotoolbox.org/) is an open-source field data collection tool optimised to build offline form-based apps.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/kobotoolbox
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mongodb | ~12.1.31 |
| https://charts.bitnami.com/bitnami | postgresql | ~11.9.13 |
| https://charts.bitnami.com/bitnami | redismain(redis) | ~16.12.3 |
| https://charts.bitnami.com/bitnami | rediscache(redis) | ~16.12.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enketo.apiKey | string | `"WEHQJCXHJ2XOBXGOGMXCUJYXQP9ZZFVY4FHLCSKJIWAWPTCMGMECGNBCHXVBFCFT1H5TQTQCKB0J7DF2X23WC7EHOCCVQ7K8CY6QO9C8NMERACUM6S2QQEER"` | Random API key |
| enketo.config | string | see `values.yaml` | Enketo configuration - will be evaluated as a template |
| enketo.encryptionKey | string | `"w0RkyuQSB33md8cZB5Xx"` | Random API key |
| enketo.image.name | string | `"enketo/enketo-express"` | Enketo image name - the web-based form preview and filling UI |
| enketo.image.tag | string | `"3.0.4"` | Enketo image tag See https://hub.docker.com/r/kobotoolbox/enketo-express-extra-widgets |
| enketo.lessSecureEncryptionKey | string | `"wUNQWPwA3bDVzckKKtS4"` | Random API key |
| enketo.logoSource | string | `""` | Logo source (data:URI or relative path in `public/images` folder) |
| enketo.replicas | int | `1` | Number of Enketo pods |
| enketo.subdomain | string | `"ee"` | DNS subdomain to serve Enketo from |
| external.google.analyticsToken | string | `""` |  |
| external.google.apiKey | string | `""` |  |
| external.ravenDSN.kobocat | string | `""` |  |
| external.ravenDSN.kpi | string | `""` |  |
| external.ravenDSN.kpiJs | string | `""` |  |
| flower.auth.authenticatedEmails | string | `"me@gmail.com|you@gmail.com"` |  |
| flower.auth.enabled | bool | `false` |  |
| flower.auth.oauthKey | string | `"auth-key"` |  |
| flower.auth.oauthSecret | string | `"auth-secret"` |  |
| flower.auth.redirectUrl.kobocat | string | `"http://flower.kobocat.com/login"` |  |
| flower.auth.redirectUrl.kpi | string | `"http://flower.kpi.com/login"` |  |
| flower.enabled | bool | `false` |  |
| flower.ports.kobocat | int | `5577` |  |
| flower.ports.kpi | int | `5566` |  |
| general.debug | bool | `false` | Enable various debug flags? |
| general.djangoSecret | string | `"EKMvRtT2RFB3xDvFty4SVCsTyaQAHS9aA2mkRqtTp9zQYz48fp"` | Random Django secret |
| general.externalDomain | string | `"example.com"` | Parent domain to serve all apps from __WARNING__: The subdomains MUST be reachable since the application will try to call itself at this address |
| general.externalPort | string | `nil` | Public URL port |
| general.externalScheme | string | `"http"` | Public URL scheme |
| general.forceInternal | bool | `false` | Set this to true in order to force internal resolution of external domains, in case those aren't reachable from inside the containers. Useful for troubleshooting, but won't work if the public scheme is https |
| general.mediaStorage.accessMode | string | `"ReadWriteOnce"` | Needs to be ReadWriteMany if you intend to scale to more than 1 pod! |
| general.mediaStorage.enabled | bool | `false` | Should we enable media volume (can be disabled if using online storage) |
| general.mediaStorage.size | string | `"10Gi"` | Storage size for uploaded media volume |
| general.mediaStorage.storageClass | string | `""` | Storage class will default to global.storageClass if provided, but can be specifically overridden here |
| general.replicas | int | `1` | Replica for the kpi+kobocat pod. __WARNING__: if using more than 1 replicas, you NEED to use a ReadWriteMany accessmode in mediaStorage.accessMode, and a storage class that supports it! |
| general.sentry.environment | string | `"development"` |  |
| general.serviceType | string | `"ClusterIP"` | Service type to expose |
| general.superUser.password | string | `"kobo"` | Admin user password |
| general.superUser.username | string | `"kobo"` | Admin user name - This user will have access to kobotoolbox UI but also the built-in Django admin interface (/admin) |
| general.supportEmail | string | `"support@example.com"` | Support email visible from the website |
| global.redis.password | string | `"brFdS9b7Xp"` | Redis password |
| global.storageClass | string | `"standard"` | Will be used by this and all subcharts |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.enabled | bool | `false` | Install ingress? |
| ingress.tls | object | `{}` | Ingress TLS settings |
| kobocat.extraEnv | object | see `values.yaml` | Dictionary of env variables to pass |
| kobocat.extraSecretEnv | object | `{}` | Azure blob storage credentials   KOBOCAT_DEFAULT_FILE_STORAGE: "kobo.apps.storage_backends.private_azure_storage.PrivateAzureStorage"   AZURE_ACCOUNT_NAME: "storage-account-name"   AZURE_CONTAINER: "storage-container-name"   AZURE_URL_EXPIRATION_SECS: "3600" |
| kobocat.image.name | string | `"kobotoolbox/kobocat"` | KoboCat docker image name |
| kobocat.image.tag | string | `"2.022.24a"` | KoboCat docker image tag see https://hub.docker.com/r/kobotoolbox/kobocat for latest tags |
| kobocat.subdomain | string | `"kc"` | DNS subdomain name to serve the form server from |
| kobocat.uwsgi_conf | string | see `values.yaml` | UWSGI Config for KoboCat |
| kpi.extraEnv | object | see `values.yaml` | Dictionary of env variables to pass |
| kpi.extraSecretEnv | object | `{}` |  |
| kpi.image.name | string | `"kobotoolbox/kpi"` | kpi docker image name See https://hub.docker.com/r/kobotoolbox/kpi for list of tags |
| kpi.image.tag | string | `"2.022.24d"` | kpi docker image tag |
| kpi.subdomain | string | `"kobo"` | DNS subdomain to serve the main UI from |
| kpi.uwsgi_conf | string | see `values.yaml` | UWSGI Config for KPI |
| mongodb | object | see `values.yaml` | Standard MongoDB values See https://artifacthub.io/packages/helm/bitnami/mongodb for doc |
| mongodb.enabled | bool | `true` | Install MongoDB? |
| nginx.image.name | string | `"nginx"` |  |
| nginx.image.tag | string | `"1.21"` |  |
| postgresql | object | see `values.yaml` | Standard postgres chart values See https://artifacthub.io/packages/helm/bitnami/postgresql for docs |
| postgresql.enabled | bool | `true` | Install Postgres? |
| postgresql.kobocatDatabase | string | `"kobocat"` | DB name for the form server |
| postgresql.kpiDatabase | string | `"koboform"` | DN name for the main Kobo UI |
| priorityClass | string | `"system-cluster-critical"` |  |
| probes.enabled | bool | `true` |  |
| rediscache.architecture | string | `"standalone"` |  |
| rediscache.enabled | bool | `true` |  |
| rediscache.usePassword | bool | `true` |  |
| redismain.architecture | string | `"standalone"` |  |
| redismain.enabled | bool | `true` |  |
| redismain.usePassword | bool | `true` |  |
| shared.extraEnv.BACKUPS_DIR | string | `"/srv/backups"` |  |
| shared.extraSecretEnv | object | `{}` |  |
| shared.initContainers | list | `[]` |  |
| shared.sidecarContainers | list | `[]` |  |
| smtp.from | string | `""` | SMTP "from" address |
| smtp.host | string | `"smtp.gmail.com"` | SMTP Host |
| smtp.password | string | `""` | SMTP Password |
| smtp.port | string | `"587"` | SMTP port |
| smtp.tls | bool | `true` | Use TLS for SMTP? |
| smtp.user | string | `""` | SMTP Username |
| uwsgiExporter.enabled | bool | `false` |  |
| uwsgiExporter.logLevel | string | `"info"` |  |
