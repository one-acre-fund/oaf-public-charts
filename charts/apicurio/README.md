# apicurio



![Version: 1.0.11](https://img.shields.io/badge/Version-1.0.11-informational?style=flat-square) 

Apicurio Studio API designer

**Homepage:** <http://www.apicur.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | yann.jouanique@gmail.com |  |

## Source Code

* <https://github.com/Apicurio/apicurio-studio>
* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/apicurio>

## TL;DR;

This chart will install an Apicurio instance, with an optional dependent Postgres backing db.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/apicurio
```

__WARNING__: The [Apicurio docs](https://www.apicur.io/studio/docs/setting-up-keycloak-for-use-with-apicurio) are wrong/incomplete about the Github integration. The documented instructions will let you login and link accounts, but NOT publish into your repository. To enable this, you will need to:

* In the default roles of your realm, add the `broker` client role named `read-token`
* Add this `read-token` `broker` role to already created users if needed
* Use at least these scopes for your Github identity provider configuration: `read:org,repo,user`

For more details, see [this ticket](https://github.com/Apicurio/apicurio-studio/issues/821).

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ~10.1.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.extraEnvVars | object | See `values.yaml` and the [container docs](https://hub.docker.com/r/apicurio/apicurio-studio-api) | Dictionary of name/value environment var pairs Will be evaluated as templates |
| api.extraEnvVars.APICURIO_LOGGING_LEVEL | string | `"INFO"` | API logging level |
| api.extraEnvVars.JAVA_TOOL_OPTIONS | string | `"-Djava.net.preferIPv4Stack=true"` | API JVM options |
| api.extraSecretEnvVars | object | `{}` | Same as `envVars` but passed as secrets |
| api.image.name | string | `"apicurio/apicurio-studio-api"` | Image name for API container |
| api.image.tag | string | `"latest"` | Image tag for API container |
| api.imagePullPolicy | string | `"IfNotPresent"` | API Image pull policy |
| api.replicas | int | `1` | API Replicas |
| api.securityContext | object | `{"runAsGroup":1000,"runAsUser":1000}` | Security context for API container |
| api.wait | bool | `true` | Wait for DB to be up? |
| database.driver | string | `"postgresql"` | DB driver - `mysql` / `postgresql` |
| database.initialize | bool | `true` | Initialize DB? |
| database.type | string | `"postgresql9"` | DB type - `postgresql9` / `mysql5` |
| general.hostname | string | `"www.example.com"` | Publicly reachable host name for the UI |
| general.serviceType | string | `"ClusterIP"` | Service type for all services |
| general.shareForEveryone | bool | `true` | Enable Share to everyone feature? |
| global.storageClass | string | `nil` | Storage class for all volumes created by this chart or subcharts |
| ingress.enabled | bool | `false` | Enable ingresses? |
| ingress.tls | list | `[]` | TLS settings |
| keycloak.client.id | string | `"apicurio-studio"` | Keycloak Client ID |
| keycloak.client.secret | string | `"apicuriokc"` | Keycloak Client Secret |
| keycloak.realm | string | `"Apicurio"` | Keycloak Realm |
| keycloak.url | string | `"https://www.example.com/auth"` | Public URL to Keycloak |
| microcks.api.url | string | `"http://www.example.com/api"` | URL to mickrocks application |
| microcks.client.id | string | `"microcks-serviceaccount"` | Microcks Client ID |
| microcks.client.secret | string | `"apicuriomr"` | Microcks Client Secret |
| postgresql.enabled | bool | `true` | Install Postgres? See See https://artifacthub.io/packages/helm/bitnami/postgresql for docs on all Postgres values |
| postgresql.host | string | `nil` | Custom db host name if not using the subchart |
| postgresql.postgresqlDatabase | string | `"apicuriodb"` | Apicurio DB name |
| postgresql.postgresqlPassword | string | `"vSX5RILHBk"` | Apicurio DB user password |
| postgresql.postgresqlUsername | string | `"apicuriodb"` | Apicurio DB user |
| postgresql.service.port | int | `5432` | postgres port |
| ui.apiUrl | string | `nil` | Override API URL - will default to `https://<.Values.general.hostname>/studio-api` |
| ui.editingUrl | string | `nil` | Override Edit URL - will default to `wss://<.Values.general.hostname>/ws` |
| ui.extraEnvVars | object | See `values.yaml` and [container docs](https://hub.docker.com/r/apicurio/apicurio-studio-ui/) | Dictionary of name/value environment var pairs Will be evaluated as templates |
| ui.extraEnvVars.APICURIO_LOGGING_LEVEL | string | `"INFO"` | UI logging level |
| ui.extraEnvVars.APICURIO_UI_FEATURE_MICROCKS | string | `"false"` | Enable Microcks integration? |
| ui.extraEnvVars.APICURIO_UI_LOGOUT_REDIRECT_URI | string | `"/"` | Redirect URI |
| ui.extraEnvVars.APICURIO_UI_VALIDATION_CHANNELNAME_REGEXP | string | `"([^{}\\/]*(\\{[a-zA-Z_][0-9a-zA-Z_]*\\})?)+"` | Channel Regex |
| ui.extraEnvVars.JAVA_TOOL_OPTIONS | string | `"-Djava.net.preferIPv4Stack=true"` | UI JVM options |
| ui.extraSecretEnvVars | object | `{}` | Same as `envVars` but passed as secrets |
| ui.image.name | string | `"apicurio/apicurio-studio-ui"` | Image name for UI container |
| ui.image.tag | string | `"latest"` | Image tag for UI container |
| ui.imagePullPolicy | string | `"IfNotPresent"` | UI Image pull policy |
| ui.replicas | int | `1` | UI Replicas |
| ui.securityContext | object | `{"runAsGroup":1000,"runAsUser":1000}` | Security context for UI container |
| ws.extraEnvVars | object | See `values.yaml` and [container docs](https://hub.docker.com/r/apicurio/apicurio-studio-ws/) | Dictionary of name/value environment var pairs Will ve evaluated as templates |
| ws.extraEnvVars.APICURIO_LOGGING_LEVEL | string | `"INFO"` | WS logging level |
| ws.extraEnvVars.JAVA_TOOL_OPTIONS | string | `"-Djava.net.preferIPv4Stack=true"` | WS JVM options |
| ws.extraSecretEnvVars | object | `{}` | Same as `envVars` but passed as secrets |
| ws.image.name | string | `"apicurio/apicurio-studio-ws"` | Image name for WS container |
| ws.image.tag | string | `"latest"` | Image tag for WS container |
| ws.imagePullPolicy | string | `"IfNotPresent"` | WS Image pull policy |
| ws.replicas | int | `1` | WS Replicas |
| ws.securityContext | object | `{"runAsGroup":1000,"runAsUser":1000}` | Security context for WS container |