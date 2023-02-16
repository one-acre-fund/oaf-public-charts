# mautic

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

A Helm chart for Kubernetes

## TL;DR;

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/kobotoolbox
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| extraEnvs | object | `{}` | See https://hub.docker.com/r/mautic/mautic |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"mautic/mautic"` |  |
| image.tag | string | `"v4-apache"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations."kubernetes.io/tls-acme" | string | `"true"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0].host | string | `"mautic.example.com"` |  |
| ingress.hosts[0].paths[0] | string | `"/"` |  |
| ingress.tls | list | `[]` |  |
| mariadb.auth.database | string | `"mautic"` |  |
| mariadb.enabled | bool | `true` |  |
| nodeSelector | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| strategy.type | string | `"Recreate"` | Since we are mounting a volume, using Recreate to avoid double-mounting |
| tolerations | list | `[]` |  |