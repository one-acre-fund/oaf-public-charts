# apicurio

![Version: 2.2.1](https://img.shields.io/badge/Version-2.2.1-informational?style=flat-square)

Apicurio Studio API designer

**Homepage:** <http://www.apicur.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | <yann.jouanique@gmail.com> |  |

## Source Code

* <https://github.com/Apicurio/apicurio-studio>
* <https://github.com/microcks/microcks>
* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/apicurio>

## TL;DR;

This chart will install an Apicurio Studio instance with an optional dependent Postgres backing db and optional Microcks API mocking platform.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/apicurio
```

## Enabling Microcks

To deploy Microcks alongside Apicurio Studio for API mocking:

```console
$ helm install my-release one-acre-fund/apicurio \
  --set microcks.enabled=true \
  --set microcks.secrets.mongodb.mongodb-passwords=<password> \
  --set microcks.secrets.mongodb.mongodb-root-password=<root-password>
```

When `microcks.enabled=true`, the Apicurio UI automatically enables Microcks integration and derives the Microcks API URL from the deployed service. You can override this with `microcks.client.apiUrl`.

## Keycloak Configuration

Keycloak is enabled by default. Configure your Keycloak instance:

```console
$ helm install my-release one-acre-fund/apicurio \
  --set keycloak.url=https://keycloak.example.com/auth \
  --set keycloak.client.id=apicurio \
  --set keycloak.client.secret=<client-secret>
```

To disable Keycloak:

```console
$ helm install my-release one-acre-fund/apicurio --set keycloak.enabled=false
```

See [KEYCLOAK-SETUP.md](KEYCLOAK-SETUP.md) for detailed client setup.

## Enabling Ingress

```console
$ helm install my-release one-acre-fund/apicurio \
  --set ingress.enabled=true \
  --set ingress.host=apicurio.example.com \
  --set ingress.tlsSecretName=my-tls-secret
```

For Microcks ingress, set `microcks.app.ingress.host`:

```console
$ helm install my-release one-acre-fund/apicurio \
  --set microcks.enabled=true \
  --set microcks.app.ingress.host=mocks.example.com \
  --set microcks.app.ingress.tlsSecretName=my-tls-secret
```

__WARNING__: The [Apicurio docs](https://www.apicur.io/studio/docs/setting-up-keycloak-for-use-with-apicurio) are wrong/incomplete about the Github integration. The documented instructions will let you login and link accounts, but NOT publish into your repository. To enable this, you will need to:

* In the default roles of your realm, add the `broker` client role named `read-token`
* Add this `read-token` `broker` role to already created users if needed
* Use at least these scopes for your Github identity provider configuration: `read:org,repo,user`

For more details, see [this ticket](https://github.com/Apicurio/apicurio-studio/issues/821).

## Known Issues

### Bloated Keycloak Tokens

If Keycloak's "Full Scope Allowed" is enabled on the `apicurio` client, the access token will include roles from ALL clients in the realm. This can inflate the token beyond the 4096-byte cookie limit, causing:

- OIDC `State verification has failed` errors (HTTP 401)
- `502 Bad Gateway` from the ingress controller (header too large)

**Fix:** In the Keycloak Admin Console:
1. Go to **Clients** > **apicurio** > **Client scopes** tab
2. Click on the **apicurio-dedicated** scope
3. Go to **Scope** tab and set **Full scope allowed** to **OFF**
4. Remove unnecessary default client scopes (keep only: `openid`, `email`, `profile`, `roles`)

### OIDC State Verification Failure (Trailing Slash)

The Apicurio UI (Quarkus-based) may fail OIDC state verification when the URL is accessed without a trailing slash. The chart sets `QUARKUS_OIDC_AUTHENTICATION_COOKIE_PATH=/` by default when `keycloak.enabled=true` to prevent this.

### PostgreSQL Password Persistence

Bitnami's PostgreSQL image only sets passwords during first initialization. Changing `postgresql.postgresqlPassword` in Helm values will NOT update the password inside an existing database. To change the password on an existing deployment:

1. `kubectl exec` into the PostgreSQL pod
2. Run `ALTER USER apicuriodb WITH PASSWORD 'new-password';`
3. Update the Helm values to match

Or delete the PVC and let Helm recreate it (data loss).

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | ~11.6.6 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.extraEnvVars | object | See `values.yaml` and the [container docs](https://hub.docker.com/r/apicurio/apicurio-studio-api) | Dictionary of name/value environment var pairs Will be evaluated as templates |
| api.extraEnvVars.APICURIO_LOGGING_LEVEL | string | `"INFO"` | API logging level |
| api.extraEnvVars.JAVA_TOOL_OPTIONS | string | `"-Djava.net.preferIPv4Stack=true"` | API JVM options |
| api.extraSecretEnvVars | object | `{}` | Same as `envVars` but passed as secrets |
| api.image.name | string | `"apicurio/apicurio-studio-api"` | Image name for API container |
| api.image.tag | string | `"0.2.62.Final"` | Image tag for API container |
| api.imagePullPolicy | string | `"IfNotPresent"` | API Image pull policy |
| api.ingress.annotations | object | `{"nginx.ingress.kubernetes.io/rewrite-target":"/$1"}` | Annotations for API ingress |
| api.ingress.ingressClassName | string | `"nginx"` | Ingress class name for API |
| api.ingress.path | string | `"/studio-api/?(.*)"` | Ingress path for API |
| api.ingress.pathType | string | `"ImplementationSpecific"` | Path type for API ingress |
| api.replicas | int | `1` | API Replicas |
| api.securityContext | object | `{"runAsGroup":1000,"runAsUser":185}` | Security context for API container |
| api.wait | bool | `true` | Wait for DB to be up? |
| database.driver | string | `"postgresql"` | DB driver - `mysql` / `postgresql` |
| database.initialize | bool | `true` | Initialize DB? |
| database.type | string | `"postgresql9"` | DB type - `postgresql9` / `mysql5` |
| general.hostname | string | `"www.example.com"` | Publicly reachable host name for the UI |
| general.serviceType | string | `"ClusterIP"` | Service type for all services |
| general.shareForEveryone | bool | `true` | Enable Share to everyone feature? |
| global.storageClass | string | `nil` | Storage class for all volumes created by this chart or subcharts |
| ingress | object | `{"enabled":false,"host":"www.example.com","tlsSecretName":""}` | Apicurio ingress configuration |
| ingress.enabled | bool | `false` | Enable ingresses for Apicurio components (api, ui, ws)? |
| ingress.host | string | `"www.example.com"` | Hostname for ingress rules |
| ingress.tlsSecretName | string | `""` | TLS secret name for ingress |
| keycloak | object | `{"client":{"id":"apicurio","secret":""},"enabled":true,"realm":"Apicurio","url":"https://www.example.com/auth"}` | Configure Keycloak/OIDC authentication |
| keycloak.client.id | string | `"apicurio"` | Keycloak Client ID |
| keycloak.client.secret | string | `""` | Keycloak Client Secret |
| keycloak.enabled | bool | `true` | Enable Keycloak/OIDC authentication |
| keycloak.realm | string | `"Apicurio"` | Keycloak Realm |
| keycloak.url | string | `"https://www.example.com/auth"` | Public URL to Keycloak |
| microcks | object | `{"app":{"containerPort":8080,"env":{"JAVA_MAJOR_VERSION":"21","JAVA_OPTIONS":"-XX:+TieredCompilation -XX:TieredStopAtLevel=2","SPRING_DATA_MONGODB_DATABASE":"microcks","SPRING_PROFILES_ACTIVE":"prod"},"grpcEnabled":false,"grpcIngress":{"annotations":{"ingress.kubernetes.io/rewrite-target":"/","nginx.ingress.kubernetes.io/backend-protocol":"GRPC","nginx.ingress.kubernetes.io/ssl-passthrough":"true"},"host":"","ingressClassName":"nginx","path":"/","pathType":"Prefix","tlsSecretName":""},"grpcService":{"port":9090,"portName":"spring-grpc"},"image":{"name":"quay.io/microcks/microcks","pullPolicy":"IfNotPresent","tag":"1.13.2"},"ingress":{"annotations":{"ingress.kubernetes.io/rewrite-target":"/"},"host":"","ingressClassName":"nginx","path":"/","pathType":"Prefix","tlsSecretName":""},"livenessProbe":{"failureThreshold":3,"httpGet":{"path":"/api/health","port":8080,"scheme":"HTTP"},"initialDelaySeconds":25,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":3},"readinessProbe":{"failureThreshold":3,"httpGet":{"path":"/api/health","port":8080,"scheme":"HTTP"},"initialDelaySeconds":35,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":3},"replicaCount":1,"resources":{"limits":{"memory":"512Mi"},"requests":{"cpu":"200m"}},"service":{"port":8080,"portName":"spring"},"startupProbe":{"failureThreshold":10,"httpGet":{"path":"/api/health","port":8080,"scheme":"HTTP"},"initialDelaySeconds":10,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":3}},"client":{"apiUrl":"","id":"microcks-serviceaccount","secret":""},"enabled":false,"keycloak":{"disableTrustManager":false,"realm":"","resource":"microcks-app"},"mongodb":{"containerPort":27017,"env":{"ALLOW_EMPTY_PASSWORD":"no","BITNAMI_DEBUG":"false","MONGODB_DISABLE_JAVASCRIPT":"no","MONGODB_DISABLE_SYSTEM_LOG":"no","MONGODB_ENABLE_DIRECTORY_PER_DB":"no","MONGODB_ENABLE_IPV6":"no","MONGODB_ENABLE_JOURNAL":"yes","MONGODB_EXTRA_DATABASES":"microcks","MONGODB_EXTRA_USERNAMES":"microcks","MONGODB_ROOT_USER":"root","MONGODB_SYSTEM_LOG_VERBOSITY":"0"},"image":{"name":"docker.io/bitnamilegacy/mongodb","pullPolicy":"IfNotPresent","tag":"8.0.13"},"persistence":{"accessMode":"ReadWriteOnce","size":"20Gi","storageClass":null},"replicaCount":1,"resources":{},"securityContext":{"container":{"runAsNonRoot":true,"runAsUser":1001},"pod":{"fsGroup":1001}},"service":{"port":27017,"portName":"mongodb"}},"postman":{"containerPort":3000,"env":{"LOG_LEVEL":"info"},"image":{"name":"quay.io/microcks/microcks-postman-runtime","pullPolicy":"IfNotPresent","tag":"1.5.0"},"livenessProbe":{"failureThreshold":3,"httpGet":{"path":"/health","port":3000,"scheme":"HTTP"},"initialDelaySeconds":4,"periodSeconds":20,"successThreshold":1,"timeoutSeconds":3},"readinessProbe":{"failureThreshold":3,"httpGet":{"path":"/health","port":3000,"scheme":"HTTP"},"initialDelaySeconds":5,"periodSeconds":20,"successThreshold":1,"timeoutSeconds":3},"replicaCount":1,"resources":{"limits":{"memory":"256Mi"}},"service":{"port":8080,"portName":"postman-runtime","targetPort":3000}},"secrets":{"mongodb":{"mongodb-passwords":"","mongodb-root-password":""}}}` | Microcks API mocking platform (optional) |
| microcks.app | object | `{"containerPort":8080,"env":{"JAVA_MAJOR_VERSION":"21","JAVA_OPTIONS":"-XX:+TieredCompilation -XX:TieredStopAtLevel=2","SPRING_DATA_MONGODB_DATABASE":"microcks","SPRING_PROFILES_ACTIVE":"prod"},"grpcEnabled":false,"grpcIngress":{"annotations":{"ingress.kubernetes.io/rewrite-target":"/","nginx.ingress.kubernetes.io/backend-protocol":"GRPC","nginx.ingress.kubernetes.io/ssl-passthrough":"true"},"host":"","ingressClassName":"nginx","path":"/","pathType":"Prefix","tlsSecretName":""},"grpcService":{"port":9090,"portName":"spring-grpc"},"image":{"name":"quay.io/microcks/microcks","pullPolicy":"IfNotPresent","tag":"1.13.2"},"ingress":{"annotations":{"ingress.kubernetes.io/rewrite-target":"/"},"host":"","ingressClassName":"nginx","path":"/","pathType":"Prefix","tlsSecretName":""},"livenessProbe":{"failureThreshold":3,"httpGet":{"path":"/api/health","port":8080,"scheme":"HTTP"},"initialDelaySeconds":25,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":3},"readinessProbe":{"failureThreshold":3,"httpGet":{"path":"/api/health","port":8080,"scheme":"HTTP"},"initialDelaySeconds":35,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":3},"replicaCount":1,"resources":{"limits":{"memory":"512Mi"},"requests":{"cpu":"200m"}},"service":{"port":8080,"portName":"spring"},"startupProbe":{"failureThreshold":10,"httpGet":{"path":"/api/health","port":8080,"scheme":"HTTP"},"initialDelaySeconds":10,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":3}}` | Microcks application settings |
| microcks.app.containerPort | int | `8080` | Microcks container port |
| microcks.app.env | object | `{"JAVA_MAJOR_VERSION":"21","JAVA_OPTIONS":"-XX:+TieredCompilation -XX:TieredStopAtLevel=2","SPRING_DATA_MONGODB_DATABASE":"microcks","SPRING_PROFILES_ACTIVE":"prod"}` | Extra environment variables for Microcks app |
| microcks.app.grpcEnabled | bool | `false` | Enable gRPC support |
| microcks.app.grpcService.port | int | `9090` | gRPC service port |
| microcks.app.grpcService.portName | string | `"spring-grpc"` | gRPC service port name |
| microcks.app.image.name | string | `"quay.io/microcks/microcks"` | Microcks image |
| microcks.app.image.pullPolicy | string | `"IfNotPresent"` | Microcks image pull policy |
| microcks.app.image.tag | string | `"1.13.2"` | Microcks image tag |
| microcks.app.ingress.host | string | `""` | Microcks ingress host |
| microcks.app.ingress.ingressClassName | string | `"nginx"` | Microcks ingress class |
| microcks.app.ingress.path | string | `"/"` | Microcks ingress path |
| microcks.app.ingress.pathType | string | `"Prefix"` | Microcks ingress path type |
| microcks.app.ingress.tlsSecretName | string | `""` | Microcks ingress TLS secret name |
| microcks.app.replicaCount | int | `1` | Microcks app replicas |
| microcks.app.resources | object | `{"limits":{"memory":"512Mi"},"requests":{"cpu":"200m"}}` | Microcks resource limits/requests |
| microcks.app.service.port | int | `8080` | Microcks service port |
| microcks.app.service.portName | string | `"spring"` | Microcks service port name |
| microcks.client | object | `{"apiUrl":"","id":"microcks-serviceaccount","secret":""}` | Client settings used by Apicurio to connect to Microcks (works regardless of whether Microcks is deployed by this chart) |
| microcks.client.apiUrl | string | `""` | Microcks API URL (auto-derived when microcks.enabled is true) |
| microcks.client.id | string | `"microcks-serviceaccount"` | Microcks service account Client ID in Keycloak |
| microcks.client.secret | string | `""` | Microcks service account Client Secret |
| microcks.enabled | bool | `false` | Enable Microcks deployment alongside Apicurio |
| microcks.keycloak | object | `{"disableTrustManager":false,"realm":"","resource":"microcks-app"}` | Microcks Keycloak settings (for Microcks' own auth) |
| microcks.keycloak.disableTrustManager | bool | `false` | Disable SSL certificate validation for Keycloak (set to true only for dev with self-signed certs) |
| microcks.keycloak.realm | string | `""` | Keycloak realm for Microcks (defaults to main keycloak.realm if not set) |
| microcks.keycloak.resource | string | `"microcks-app"` | Keycloak resource/client ID for Microcks backend |
| microcks.mongodb | object | `{"containerPort":27017,"env":{"ALLOW_EMPTY_PASSWORD":"no","BITNAMI_DEBUG":"false","MONGODB_DISABLE_JAVASCRIPT":"no","MONGODB_DISABLE_SYSTEM_LOG":"no","MONGODB_ENABLE_DIRECTORY_PER_DB":"no","MONGODB_ENABLE_IPV6":"no","MONGODB_ENABLE_JOURNAL":"yes","MONGODB_EXTRA_DATABASES":"microcks","MONGODB_EXTRA_USERNAMES":"microcks","MONGODB_ROOT_USER":"root","MONGODB_SYSTEM_LOG_VERBOSITY":"0"},"image":{"name":"docker.io/bitnamilegacy/mongodb","pullPolicy":"IfNotPresent","tag":"8.0.13"},"persistence":{"accessMode":"ReadWriteOnce","size":"20Gi","storageClass":null},"replicaCount":1,"resources":{},"securityContext":{"container":{"runAsNonRoot":true,"runAsUser":1001},"pod":{"fsGroup":1001}},"service":{"port":27017,"portName":"mongodb"}}` | MongoDB settings for Microcks |
| microcks.mongodb.containerPort | int | `27017` | MongoDB container port |
| microcks.mongodb.env | object | `{"ALLOW_EMPTY_PASSWORD":"no","BITNAMI_DEBUG":"false","MONGODB_DISABLE_JAVASCRIPT":"no","MONGODB_DISABLE_SYSTEM_LOG":"no","MONGODB_ENABLE_DIRECTORY_PER_DB":"no","MONGODB_ENABLE_IPV6":"no","MONGODB_ENABLE_JOURNAL":"yes","MONGODB_EXTRA_DATABASES":"microcks","MONGODB_EXTRA_USERNAMES":"microcks","MONGODB_ROOT_USER":"root","MONGODB_SYSTEM_LOG_VERBOSITY":"0"}` | MongoDB environment variables |
| microcks.mongodb.image.name | string | `"docker.io/bitnamilegacy/mongodb"` | MongoDB image |
| microcks.mongodb.image.pullPolicy | string | `"IfNotPresent"` | MongoDB image pull policy |
| microcks.mongodb.image.tag | string | `"8.0.13"` | MongoDB image tag |
| microcks.mongodb.persistence.accessMode | string | `"ReadWriteOnce"` | MongoDB PVC access mode |
| microcks.mongodb.persistence.size | string | `"20Gi"` | MongoDB PVC size |
| microcks.mongodb.persistence.storageClass | string | `nil` | MongoDB storage class (uses global.storageClass if not set) |
| microcks.mongodb.replicaCount | int | `1` | MongoDB replicas |
| microcks.mongodb.resources | object | `{}` | MongoDB resource limits/requests |
| microcks.mongodb.securityContext.container.runAsNonRoot | bool | `true` | Run MongoDB as non-root |
| microcks.mongodb.securityContext.container.runAsUser | int | `1001` | MongoDB container user ID |
| microcks.mongodb.securityContext.pod.fsGroup | int | `1001` | MongoDB pod fsGroup |
| microcks.mongodb.service.port | int | `27017` | MongoDB service port |
| microcks.mongodb.service.portName | string | `"mongodb"` | MongoDB service port name |
| microcks.postman | object | `{"containerPort":3000,"env":{"LOG_LEVEL":"info"},"image":{"name":"quay.io/microcks/microcks-postman-runtime","pullPolicy":"IfNotPresent","tag":"1.5.0"},"livenessProbe":{"failureThreshold":3,"httpGet":{"path":"/health","port":3000,"scheme":"HTTP"},"initialDelaySeconds":4,"periodSeconds":20,"successThreshold":1,"timeoutSeconds":3},"readinessProbe":{"failureThreshold":3,"httpGet":{"path":"/health","port":3000,"scheme":"HTTP"},"initialDelaySeconds":5,"periodSeconds":20,"successThreshold":1,"timeoutSeconds":3},"replicaCount":1,"resources":{"limits":{"memory":"256Mi"}},"service":{"port":8080,"portName":"postman-runtime","targetPort":3000}}` | Postman runtime settings |
| microcks.postman.containerPort | int | `3000` | Postman container port |
| microcks.postman.env | object | `{"LOG_LEVEL":"info"}` | Postman environment variables |
| microcks.postman.image.name | string | `"quay.io/microcks/microcks-postman-runtime"` | Postman runtime image |
| microcks.postman.image.pullPolicy | string | `"IfNotPresent"` | Postman runtime image pull policy |
| microcks.postman.image.tag | string | `"1.5.0"` | Postman runtime image tag |
| microcks.postman.replicaCount | int | `1` | Postman replicas |
| microcks.postman.resources | object | `{"limits":{"memory":"256Mi"}}` | Postman resource limits/requests |
| microcks.postman.service.port | int | `8080` | Postman service port |
| microcks.postman.service.portName | string | `"postman-runtime"` | Postman service port name |
| microcks.postman.service.targetPort | int | `3000` | Postman service target port |
| microcks.secrets | object | `{"mongodb":{"mongodb-passwords":"","mongodb-root-password":""}}` | Microcks secrets |
| microcks.secrets.mongodb.mongodb-passwords | string | `""` | MongoDB user password |
| microcks.secrets.mongodb.mongodb-root-password | string | `""` | MongoDB root password |
| postgresql.auth.database | string | `"apicuriodb"` | Apicurio DB name |
| postgresql.auth.password | string | `""` | Apicurio DB user password |
| postgresql.auth.username | string | `"apicuriodb"` | Apicurio DB user |
| postgresql.enabled | bool | `true` | Install Postgres? See https://artifacthub.io/packages/helm/bitnami/postgresql for docs on all Postgres values |
| postgresql.host | string | `nil` | Custom db host name if not using the subchart |
| postgresql.image.registry | string | `"docker.io"` |  |
| postgresql.image.repository | string | `"bitnamilegacy/postgresql"` |  |
| postgresql.service.port | int | `5432` | postgres port |
| ui.apiUrl | string | `nil` | Override API URL - will default to `https://<.Values.general.hostname>/studio-api` |
| ui.editingUrl | string | `nil` | Override Edit URL - will default to `wss://<.Values.general.hostname>/ws` |
| ui.extraEnvVars | object | See `values.yaml` and [container docs](https://hub.docker.com/r/apicurio/apicurio-studio-ui/) | Dictionary of name/value environment var pairs Will be evaluated as templates |
| ui.extraEnvVars.APICURIO_LOGGING_LEVEL | string | `"INFO"` | UI logging level |
| ui.extraEnvVars.APICURIO_UI_VALIDATION_CHANNELNAME_REGEXP | string | `"([^{}\\/]*(\\{[a-zA-Z_][0-9a-zA-Z_]*\\})?)+"` | Channel Regex |
| ui.extraEnvVars.JAVA_TOOL_OPTIONS | string | `"-Djava.net.preferIPv4Stack=true"` | UI JVM options |
| ui.extraSecretEnvVars | object | `{}` | Same as `envVars` but passed as secrets |
| ui.image.name | string | `"apicurio/apicurio-studio-ui"` | Image name for UI container |
| ui.image.tag | string | `"0.2.62.Final"` | Image tag for UI container |
| ui.imagePullPolicy | string | `"IfNotPresent"` | UI Image pull policy |
| ui.ingress.annotations | object | `{}` | Annotations for UI ingress |
| ui.ingress.ingressClassName | string | `"nginx"` | Ingress class name for UI |
| ui.ingress.path | string | `"/"` | Ingress path for UI |
| ui.ingress.pathType | string | `"Prefix"` | Path type for UI ingress |
| ui.replicas | int | `1` | UI Replicas |
| ui.securityContext | object | `{"runAsGroup":1000,"runAsUser":185}` | Security context for UI container |
| ws.extraEnvVars | object | See `values.yaml` and [container docs](https://hub.docker.com/r/apicurio/apicurio-studio-ws/) | Dictionary of name/value environment var pairs Will be evaluated as templates |
| ws.extraEnvVars.APICURIO_LOGGING_LEVEL | string | `"INFO"` | WS logging level |
| ws.extraEnvVars.JAVA_TOOL_OPTIONS | string | `"-Djava.net.preferIPv4Stack=true"` | WS JVM options |
| ws.extraSecretEnvVars | object | `{}` | Same as `envVars` but passed as secrets |
| ws.image.name | string | `"apicurio/apicurio-studio-ws"` | Image name for WS container |
| ws.image.tag | string | `"0.2.62.Final"` | Image tag for WS container |
| ws.imagePullPolicy | string | `"IfNotPresent"` | WS Image pull policy |
| ws.ingress.annotations | object | `{"ingress.kubernetes.io/proxy-connect-timeout":"3600","ingress.kubernetes.io/proxy-read-timeout":"3600","ingress.kubernetes.io/proxy-send-timeout":"3600","ingress.kubernetes.io/send-timeout":"3600","nginx.ingress.kubernetes.io/configuration-snippet":"proxy_set_header Upgrade $http_upgrade;\nproxy_set_header Connection $connection_upgrade;\n","nginx.ingress.kubernetes.io/rewrite-target":"/$1"}` | Annotations for WS ingress |
| ws.ingress.ingressClassName | string | `"nginx"` | Ingress class name for WS |
| ws.ingress.path | string | `"/ws/?(.*)"` | Ingress path for WS |
| ws.ingress.pathType | string | `"ImplementationSpecific"` | Path type for WS ingress |
| ws.replicas | int | `1` | WS Replicas |
| ws.securityContext | object | `{"runAsGroup":1000,"runAsUser":185}` | Security context for WS container |
