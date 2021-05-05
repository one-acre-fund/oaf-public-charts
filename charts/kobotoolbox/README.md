# kobotoolbox

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

Helm Chart for KoboToolbox

**Homepage:** <https://github.com/one-acre-fund/kobo-k8s>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | yann.jouanique@gmail.com |  |

## Source Code

* <https://github.com/one-acre-fund/kobo-k8s>

## TL;DR;

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/kobotoolbox
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mongodb | ~10.1.3 |
| https://charts.bitnami.com/bitnami | postgresql | ~10.1.2 |
| https://charts.bitnami.com/bitnami | redismain(redis) | ~10.7.4 |
| https://charts.bitnami.com/bitnami | rediscache(redis) | ~10.7.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enketo.apiKey | string | `"WEHQJCXHJ2XOBXGOGMXCUJYXQP9ZZFVY4FHLCSKJIWAWPTCMGMECGNBCHXVBFCFT1H5TQTQCKB0J7DF2X23WC7EHOCCVQ7K8CY6QO9C8NMERACUM6S2QQEER"` |  |
| enketo.config | string | `"{\n  \"app name\": \"Enketo Express for KoBo Toolbox\",\n  \"linked form and data server\": {\n    \"name\": \"KoBo Toolbox\",\n    \"server url\": \"\",\n    \"api key\": \"{{ .Values.enketo.apiKey }}\"\n  },\n  \"encryption key\": \"{{ .Values.enketo.encryptionKey }}\",\n  \"less secure encryption key\": \"{{ .Values.enketo.lessSecureEncryptionKey }}\",\n  \"widgets\": [\n    \"note\",\n    \"select-desktop\",\n    \"select-mobile\",\n    \"autocomplete\",\n    \"geo\",\n    \"textarea\",\n    \"url\",\n    \"table\",\n    \"radio\",\n    \"date\",\n    \"time\",\n    \"datetime\",\n    \"select-media\",\n    \"file\",\n    \"draw\",\n    \"rank\",\n    \"likert\",\n    \"range\",\n    \"columns\",\n    \"image-view\",\n    \"comment\",\n    \"image-map\",\n    \"date-native\",\n    \"date-native-ios\",\n    \"date-mobile\",\n    \"text-max\",\n    \"text-print\",\n    \"rating\",\n    \"thousands-sep\",\n    \"../../../node_modules/enketo-image-customization-widget/image-customization\",\n    \"../../../node_modules/enketo-literacy-test-widget/literacywidget\"\n  ],\n  \"redis\": {\n    \"cache\": {\n      \"host\": \"{{ .Release.Name }}-rediscache-master\",\n      {{- if .Values.rediscache.usePassword }}\n      \"password\": \"{{ .Values.global.redis.password }}\",\n      {{- end }}\n      \"port\": \"6379\"\n    },\n    \"main\": {\n      \"host\": \"{{ .Release.Name }}-redismain-master\",\n      {{- if .Values.redismain.usePassword }}\n      \"password\": \"{{ .Values.global.redis.password }}\",\n      {{- end }}\n      \"port\": \"6379\"\n    }\n  },\n  \"google\": {\n    \"api key\": \"{{ .Values.external.google.apiKey }}\",\n    \"analytics\": {\n      \"ua\": \"{{ .Values.external.google.analyticsToken }}\",\n      \"domain\": \"{{ .Values.general.externalScheme }}://{{ .Values.enketo.subdomain }}.{{ .Values.general.externalDomain }}{{ .Values.general.publicPort }}\"\n    }\n  },\n  \"payload limit\": \"1mb\",\n  \"text field character limit\": 1000000,\n  \"maps\": [\n    {\n      \"name\": \"humanitarian\",\n      \"tiles\": [ \"https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png\" ],\n      \"attribution\": \"&copy; <a href=\\\"http://openstreetmap.org\\\">OpenStreetMap</a> & <a href=\\\"https://www.hotosm.org/updates/2013-09-29_a_new_window_on_openstreetmap_data\\\">Yohan Boniface & Humanitarian OpenStreetMap Team</a> | <a href=\\\"https://www.openstreetmap.org/copyright\\\">Terms</a>\"\n    },\n    {\n      \"name\": \"satellite\",\n      \"tiles\": [ \"https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}\" ],\n      \"attribution\": \"Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community\"\n    },\n    {\n      \"name\": \"terrain\",\n      \"tiles\": [ \"https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png\" ],\n      \"attribution\": \"&copy; <a href=\\\"https://openstreetmap.org\\\">OpenStreetMap</a> | <a href=\\\"https://www.openstreetmap.org/copyright\\\">Terms</a>\"\n    },\n    {\n      \"name\": \"streets\",\n      \"tiles\": [ \"https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png\" ],\n      \"attribution\": \"&copy; <a href=\\\"https://openstreetmap.org\\\">OpenStreetMap</a> | <a href=\\\"https://www.openstreetmap.org/copyright\\\">Terms</a>\"\n    }\n  ]\n}"` |  |
| enketo.encryptionKey | string | `"w0RkyuQSB33md8cZB5Xx"` |  |
| enketo.image.name | string | `"kobotoolbox/enketo-express-extra-widgets"` |  |
| enketo.image.tag | string | `"2.6.1"` |  |
| enketo.lessSecureEncryptionKey | string | `"wUNQWPwA3bDVzckKKtS4"` |  |
| enketo.replicas | int | `1` |  |
| enketo.subdomain | string | `"ee"` |  |
| external.google.analyticsToken | string | `""` |  |
| external.google.apiKey | string | `""` |  |
| external.ravenDSN.kobocat | string | `""` |  |
| external.ravenDSN.kpi | string | `""` |  |
| external.ravenDSN.kpiJs | string | `""` |  |
| general.debug | bool | `false` |  |
| general.djangoSecret | string | `"EKMvRtT2RFB3xDvFty4SVCsTyaQAHS9aA2mkRqtTp9zQYz48fp"` |  |
| general.externalDomain | string | `"example.com"` |  |
| general.externalPort | string | `nil` |  |
| general.externalScheme | string | `"http"` |  |
| general.forceInternal | bool | `false` |  |
| general.mediaStorage.accessMode | string | `"ReadWriteOnce"` |  |
| general.mediaStorage.size | string | `"10Gi"` |  |
| general.mediaStorage.storageClass | string | `""` |  |
| general.replicas | int | `1` |  |
| general.serviceType | string | `"ClusterIP"` |  |
| general.superUser.password | string | `"kobo"` |  |
| general.superUser.username | string | `"kobo"` |  |
| general.supportEmail | string | `"support@example.com"` |  |
| global.redis.password | string | `"brFdS9b7Xp"` |  |
| global.storageClass | string | `"standard"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.tls | object | `{}` |  |
| kobocat.extraEnv | object | `{}` |  |
| kobocat.image.name | string | `"kobotoolbox/kobocat"` |  |
| kobocat.image.tag | string | `"2.021.09"` |  |
| kobocat.subdomain | string | `"kc"` |  |
| kpi.extraEnv | object | `{}` |  |
| kpi.image.name | string | `"kobotoolbox/kpi"` |  |
| kpi.image.tag | string | `"2.021.12b"` |  |
| kpi.signupPhoto | string | `""` |  |
| kpi.subdomain | string | `"kobo"` |  |
| mongodb.auth.database | string | `"formhub"` |  |
| mongodb.auth.password | string | `"kobo"` |  |
| mongodb.auth.rootPassword | string | `"kobo"` |  |
| mongodb.auth.username | string | `"kobo"` |  |
| mongodb.enabled | bool | `true` |  |
| mongodb.initdbScripts."create-user.js" | string | `"db.createUser({\n  user: \"{{ .Values.auth.username }}\",\n  pwd: \"{{ .Values.auth.password }}\",\n  roles: [ { role: 'readWrite', db: \"{{ .Values.auth.database }}\" } ]\n})\n"` |  |
| mongodb.initdbScripts."index.js" | string | `"db.getSiblingDB('{{ .Values.auth.database }}').instances.createIndex( { _userform_id: 1 } )\n"` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.initdbScriptsConfigMap | string | `"{{ .Release.Name }}-postgres-init"` |  |
| postgresql.kobocatDatabase | string | `"kobocat"` |  |
| postgresql.kpiDatabase | string | `"koboform"` |  |
| postgresql.postgresqlPassword | string | `"kobo"` |  |
| postgresql.postgresqlPostgresPassword | string | `"admin"` |  |
| postgresql.postgresqlUsername | string | `"kobo"` |  |
| rediscache.cluster.enabled | bool | `false` |  |
| rediscache.cluster.slaveCount | int | `1` |  |
| rediscache.enabled | bool | `true` |  |
| rediscache.usePassword | bool | `true` |  |
| redismain.cluster.enabled | bool | `false` |  |
| redismain.cluster.slaveCount | int | `1` |  |
| redismain.enabled | bool | `true` |  |
| redismain.usePassword | bool | `true` |  |
| smtp.from | string | `""` |  |
| smtp.host | string | `"smtp.gmail.com"` |  |
| smtp.password | string | `""` |  |
| smtp.port | string | `"587"` |  |
| smtp.tls | bool | `true` |  |
| smtp.user | string | `""` |  |