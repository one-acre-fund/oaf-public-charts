# flagsmith



![Version: 0.1.3](https://img.shields.io/badge/Version-0.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) 

Flagsmith - a Feature flag and remote configuration solution

**Homepage:** <https://flagsmith.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | yann.jouanique@gmail.com |  |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/flagsmith>

## TL;DR;

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/flagsmith
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ~10.1.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| flagsmith.admin.email | string | `"admin@example.com"` | Admin email address |
| flagsmith.admin.firstName | string | `"admin"` | Admin user |
| flagsmith.admin.lastName | string | `"admin"` | Admin user |
| flagsmith.admin.password | string | `"x1Hw138BCy"` | Admin password |
| flagsmith.api.extraEnv | object | `{"DJANGO_ALLOWED_HOSTS":"*","DJANGO_CSRF_TRUSTED_ORIGINS":"{{ .Values.flagsmith.externalURL.web.domain | quote }}"}` | Dictionary of env var key/values. Will be evaluated as a template. See `values.yaml` for defaults, and the docs at https://github.com/Flagsmith/flagsmith-api |
| flagsmith.api.extraSecretEnv | object | `{}` | Same as `extraEnv` but passed as `Secret`. Will be evaluated as a template |
| flagsmith.api.image | string | `"flagsmith/flagsmith-api"` | API docker image name |
| flagsmith.api.init.initAdminUser | bool | `true` | Should we create admin user? |
| flagsmith.api.init.initialSetup.environments | list | `[]` | List of Environments to create, if an organization/project is provided |
| flagsmith.api.init.initialSetup.features | object | see `values.yaml` | Dictionary of Features to create, if an organization/project/environment is provided |
| flagsmith.api.init.initialSetup.organizationName | string | `""` | Organization name to create if needed? |
| flagsmith.api.init.initialSetup.projectName | string | `""` | Create Project name to create if needed, if an organization is provided |
| flagsmith.api.replicas | int | `1` | API pods |
| flagsmith.api.tag | string | `"v2.6.0"` | API docker image tag |
| flagsmith.api.wait | bool | `true` | Wait for dependencies (postgres)? |
| flagsmith.debug | bool | `false` | Enable some debug logging? |
| flagsmith.djangoSecret | string | `"NXdxCtOWfK"` | Override this to some secret key |
| flagsmith.externalURL.api.domain | string | `"example.com"` | Public address domain for the API |
| flagsmith.externalURL.api.path | string | `"/api/v1"` | Public API path |
| flagsmith.externalURL.api.port | string | `""` | Public address port for the API |
| flagsmith.externalURL.api.scheme | string | `"https"` | Public address scheme for the API |
| flagsmith.externalURL.web.domain | string | `"example.com"` | Public address domain for the UI |
| flagsmith.externalURL.web.port | string | `""` | Public address port for the UI (leave empty for default 80/443 based on protocol) |
| flagsmith.externalURL.web.scheme | string | `"https"` | Public address scheme for the UI |
| flagsmith.extraConf | string | `""` | Free-text extra python conf to append to common.py (see https://github.com/Flagsmith/flagsmith-api/blob/master/src/app/settings/common.py) |
| flagsmith.frontend.extraEnv | object | `{}` | Dictionary of env var key/values. Will be evaluated as a template. See https://hub.docker.com/r/flagsmith/flagsmith-frontend |
| flagsmith.frontend.extraSecretEnv | object | `{}` | Same as `extraEnv` but passed as `Secret`. Will be evaluated as a template |
| flagsmith.frontend.image | string | `"flagsmith/flagsmith-frontend"` | UI image name |
| flagsmith.frontend.replicas | int | `1` | Number of UI pods |
| flagsmith.frontend.tag | string | `"v2.6.0"` | UI image tag |
| flagsmith.frontend.useOwnFlagsmithApi | bool | `false` | Should we use this installation's API server to fetch Flagsmith customizations? |
| flagsmith.frontend.wait | bool | `true` | Wait for API to be up? |
| general.serviceType | string | `"ClusterIP"` | This will be applied to all services |
| global.storageClass | string | `"standard"` | This will be used on all pods for all PVCs, including dependencies (Redis...) |
| ingress.annotations | object | `{"nginx.ingress.kubernetes.io/proxy-body-size":"100M"}` | Ingress annotations dictionary |
| ingress.enabled | bool | `false` | Install ingress? |
| ingress.tls | object | `{}` | Ingress TLS settings |
| postgresql | object | see `values.yaml` | Postgres settings - See https://artifacthub.io/packages/helm/bitnami/postgresql for docs |
| postgresql.enabled | bool | `true` | Install postgres chart? |
| resources | object | `{"limits":{"cpu":"200m","memory":"200Mi"},"requests":{"cpu":"50m","memory":"100Mi"}}` | Resource specifications to apply to each container |
| securityContext | object | `{"runAsGroup":1000,"runAsUser":1000}` | SecurityContext to apply to all pods |
| tests.enabled | bool | `true` |  |