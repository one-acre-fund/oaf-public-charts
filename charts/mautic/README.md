# mautic

![Version: 0.1.3](https://img.shields.io/badge/Version-0.1.3-informational?style=flat-square)

A Helm chart for Mautic, a marketing automation tool

**Homepage:** <https://www.mautic.org/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann-J | <yann.jouanique@gmail.com> |  |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/mautic>

## TL;DR

[Mautic](https://www.mautic.org/) is an open-source marketing campaign automation tool.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/mautic
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb | ~11.4.6 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| extraEnvs | object | `{}` | Dictionary of env vars, see https://hub.docker.com/r/mautic/mautic for possible values |
| extraSecretEnvs | object | `{}` | Same as `extraEnvs` but passed as a secret |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"mautic/mautic"` |  |
| image.tag | string | `"v4-apache"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress | object | see `values.yaml` | Ingress definition |
| ingress.enabled | bool | `true` | Enable ingress? |
| mariadb | object | see `values.yaml` | Mariadb subchart configuration, see https://artifacthub.io/packages/helm/bitnami/mariadb for docs |
| mariadb.enabled | bool | `true` | Enable Mariadb chart? |
| nodeSelector | object | `{}` |  |
| persistence.existingClaim | string | `""` |  |
| probes | object | See `values.yaml` | Probes definitions |
| replicaCount | int | `1` | __WARNING__: if using multiple nodes, you will need to use a `ReadWriteMany` storage class |
| resources | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| strategy.type | string | `"Recreate"` | Since we are mounting a volume, using `Recreate` to avoid double-mounting |
| tolerations | list | `[]` |  |
| volume.enabled | bool | `true` |  |
| volume.spec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| volume.spec.resources.requests.storage | string | `"1Gi"` |  |
