# scoold

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

Scoold - Stack Overflow in a JAR

**Homepage:** <https://scoold.com>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Yann Jouanique | <yann.jouanique@oneacrefund.org> |  |

## Source Code

* <https://github.com/Erudika/scoold>

## TL;DR

This chart will install a standalone instance of [Scoold](https://scoold.com/), that can be backed by any Para backend instance (cloud or self-hosted). It was inspired by the official Helm chart, but this seems to be unmaintained, and was not working at the time of trying it.

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/scoold
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| applicationConf | string | `"scoold.env = production\nscoold.para_endpoint = \"https://paraio.com\"\nscoold.para_access_key = \"app:scoold\"\nscoold.para_secret_key = \"secret\"\n#scoold.password_auth_enabled = true\n#scoold.is_default_space_public = true\n####################################\n# Add more config properties here...\n####################################\n"` | This is the main Scoold application configuration file. It is mounted as a `secret` to the container, so sensitive information is fine See the [Scoold README](https://github.com/Erudika/scoold) for more details |
| extraEnvs | object | `{}` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.registry | string | `"docker.io"` |  |
| image.repository | string | `"erudikaltd/scoold"` |  |
| image.tag | string | `"latest_stable"` |  |
| ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0] | string | `"scoold.local"` |  |
| ingress.paths[0] | string | `"/"` |  |
| ingress.tls | list | `[]` |  |
| javaOpts | string | `"-Xmx512m -Xms512m -Dconfig.file=/scoold/config/application.conf"` |  |
| nodeSelector | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| service.name | string | `"http"` |  |
| service.port | int | `8000` |  |
| service.type | string | `"ClusterIP"` |  |
| tolerations | list | `[]` |  |
| updateStrategy | string | `"RollingUpdate"` |  |