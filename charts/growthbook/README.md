# growthbook

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square)

A Helm chart for Growthbook

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| bisonlou | <bisonlou@gmail.com> |  |
| orchide | <orchideirakoze@gmail.com> |  |

## TL;DR;

[GrowthBook](https://www.growthbook.io/) is an open-source remote configuration / activation flag service.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/growthbook
```

## Managing credentials outside the chart

By default the chart creates the Secret holding `JWT_SECRET`, `ENCRYPTION_KEY`,
`MONGODB_URI` and — when the matching feature is enabled — `EMAIL_HOST_PASSWORD`,
`LICENSE_KEY` and `SSO_CONFIG`, from the values you supply.

Set `growthbookSecret.create=false` to have something else own it (ExternalSecrets,
sealed secrets, or a Secret you apply yourself). The Deployment still reads every
credential from that Secret by name, so it must supply all of the keys above.

**Migrating an existing release is order-sensitive.** Flipping `create` to `false`
removes the Secret from the chart's desired state, and `helm upgrade` will delete
the one it previously managed — while the Deployment still references it by name.
Losing it mid-upgrade fails the rollout and destroys the credential data.

Do it in this order:

1. Create the external Secret **first**, using the same name the chart used —
   `growthbookSecret.name` if set, otherwise the release fullname. Copy the
   existing values across; `ENCRYPTION_KEY` in particular cannot be regenerated
   without re-encrypting stored data.
2. Confirm it holds every key the Deployment reads.
3. Only then upgrade with `growthbookSecret.create=false`.

Under GitOps the same ordering applies. With ArgoCD, give the ExternalSecret
`argocd.argoproj.io/sync-wave: "-1"` so it reconciles before the Deployment, and
leave pruning disabled for the first sync so the previously Helm-managed Secret
is not removed before its replacement exists.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami/ | mongodb | ~13.6.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| growthbook.datasource.google.clientId | string | `nil` |  |
| growthbook.datasource.google.clientSecret | string | `nil` |  |
| growthbook.datasource.google.enabled | bool | `false` |  |
| growthbook.email.enabled | bool | `false` |  |
| growthbook.email.host | string | `nil` |  |
| growthbook.email.hostPassword | string | `nil` |  |
| growthbook.email.hostUser | string | `nil` |  |
| growthbook.email.port | int | `25` |  |
| growthbook.email.senderEmail | string | `nil` |  |
| growthbook.email.siteManagerEmail | string | `nil` |  |
| growthbook.encryptionKey | string | `"encryptionKeyString"` |  |
| growthbook.externalMongodbUri | string | `nil` |  |
| growthbook.extraEnvVars.API_HOST | string | `"https://my-api-host.io:443"` |  |
| growthbook.extraEnvVars.APP_ORIGIN | string | `"https://my-app-origin.io:443"` |  |
| growthbook.extraEnvVars.NODE_ENV | string | `"production"` |  |
| growthbook.jwtSecret | string | `"jwtSecretString"` |  |
| growthbook.persistence.accessModes[0] | string | `"ReadWriteMany"` |  |
| growthbook.persistence.enabled | bool | `true` |  |
| growthbook.persistence.storage | string | `"3Gi"` |  |
| growthbook.persistence.type | string | `"emptyDir"` |  |
| growthbook.sso.enabled | bool | `false` |  |
| growthbook.sso.licenseKey | string | `nil` |  |
| growthbook.sso.ssoConfig | object | `{}` |  |
| growthbookSecret.create | bool | `true` | Create the Secret holding GrowthBook's credentials. Set false when ExternalSecrets or similar owns it — see "Managing credentials outside the chart". |
| growthbookSecret.name | string | `""` | Name of that Secret. Defaults to the release fullname. |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"growthbook/growthbook"` |  |
| image.tag | string | `"latest"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/cors-allow-headers" | string | `"Authorization,Referer,sec-ch-ua,sec-ch-ua-mobile,sec-ch-ua-platform,User-Agent,X-Organization,Content-Type"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/cors-allow-origin" | string | `"https://my-app-origin.io"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/enable-cors" | string | `"true"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/force-ssl-redirect" | string | `"true"` |  |
| ingress.apiHostName | string | `"my-api-host.io"` |  |
| ingress.appOriginName | string | `"my-app-origin.io"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.name | string | `"growthbook-ingress"` |  |
| ingress.secretName | string | `"growthbook-tls"` |  |
| mongodb.architecture | string | `"standalone"` |  |
| mongodb.auth.database | string | `"growthbook-db"` |  |
| mongodb.auth.password | string | `"growthbook"` |  |
| mongodb.auth.rootPassword | string | `"password"` |  |
| mongodb.auth.rootUser | string | `"root"` |  |
| mongodb.auth.username | string | `"growthbook"` |  |
| mongodb.enabled | bool | `true` | Install MongoDB? |
| mongodb.initdbScripts."grant-role.js" | string | `"db = db.getSiblingDB('{{ .Values.auth.database }}')\ndb.grantRolesToUser(\"{{ .Values.auth.username }}\", [{ role: 'readWrite', db: \"{{ .Values.auth.database }}\" }])\n"` |  |
| mongodb.replicaSetName | string | `"rs0"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| port.backendPort | int | `3100` |  |
| port.frontendPort | int | `3000` |  |
| replicaCount | int | `1` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| volume.mountPath | string | `"/usr/local/src/app/packages/back-end/uploads"` |  |
| volume.name | string | `"uploads-persistent-storage"` |  |
