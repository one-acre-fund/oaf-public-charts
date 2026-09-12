# Praeco Helm Chart

**This Helm Chart is Beta Release.**

[Praeco](https://github.com/johnsusek/praeco) is a very useful Web GUI for [elastalert2](https://github.com/jertel/elastalert2).

[elastalert2](https://github.com/jertel/elastalert2) is a simple framework for alerting on anomalies, spikes, or other patterns of interest from data in Elasticsearch.

## Compatibility
**This chart supports ES7, ES8.**

If there are many requests, I'll consider to support ES6. I think that switching container tag enables to support other ES ver. (Container Image Tags are not implemented...)

See the comment in the default `values.yaml` to know why `writebackIndex` is required for ES 6.x.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add daichi703n https://daichi703n.github.io/charts/stable 
$ helm install --name my-release daichi703n/praeco
```

### with Slack

```console
$ helm install --name my-release daichi703n/praeco \
    --set elastalert.slack_webhook_url=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK \
    --set elastalert.extraConfigOptions.slack_ignore_ssl_errors=true
```

Please refer to the Configurations and `vars.yml.example`.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

## Configuration

Configurations for ElastAlert is cloned from [ElastAlert Helm](https://github.com/helm/charts/tree/master/stable/elastalert).

| Parameter                                    | Description                                                                                | Default                              |
|----------------------------------------------|--------------------------------------------------------------------------------------------|--------------------------------------|
| `image.repository`                           | docker image                                                                               | praecoapp/praeco                     |
| `image.tag`                                  | docker image tag                                                                           | latest                               |
| `image.pullPolicy`                           | image pull policy                                                                          | IfNotPresent                         |
| `elastalert.image.repository`                | docker image                                                                               | praecoapp/elastalert-server          |
| `elastalert.image.tag`                       | docker image tag                                                                           | "20230219"                           |
| `elastalert.image.pullPolicy`                | image pull policy                                                                          | IfNotPresent                         |
| `elastalert.podAnnotations`                  | Annotations to be added to pods                                                            | {}                                   |
| `elastalert.command`                         | command override for container                                                             | `NULL`                               |
| `elastalert.args`                            | args override for container                                                                | `NULL`                               |
| `elastalert.replicaCount`                    | number of replicas to run                                                                  | 1                                    |
| `elastalert.elasticsearch.host`              | elasticsearch endpoint to use                                                              | elasticsearch                        |
| `elastalert.elasticsearch.port`              | elasticsearch port to use                                                                  | 80                                   |
| `elastalert.elasticsearch.useSsl`            | whether or not to connect to es_host using SSL                                             | False                                |
| `elastalert.elasticsearch.username`          | Username for ES with basic auth                                                            | `NULL`                               |
| `elastalert.elasticsearch.password`          | Password for ES with basic auth                                                            | `NULL`                               |
| `elastalert.elasticsearch.verifyCerts`       | whether or not to verify TLS certificates                                                  | True                                 |
| `elastalert.elasticsearch.clientCert`        | path to a PEM certificate to use as the client certificate                                 | /certs/client.pem                    |
| `elastalert.elasticsearch.clientKey`         | path to a private key file to use as the client key                                        | /certs/client-key.pem                |
| `elastalert.elasticsearch.caCerts`           | path to a CA cert bundle to use to verify SSL connections                                  | /certs/ca.pem                        |
| `elastalert.elasticsearch.certsVolumes`      | certs volumes, required to mount ssl certificates when elasticsearch has tls enabled       | `NULL`                               |
| `elastalert.elasticsearch.certsVolumeMounts` | mount certs volumes, required to mount ssl certificates when elasticsearch has tls enabled | `NULL`                               |
| `elastalert.extraConfigOptions`              | Additional options to propagate to all rules, cannot be `alert`, `type`, `name` or `index` | `{}`                                 |
| `elastalert.optEnv`                          | Additional pod environment variable definitions                                            | []                                   |
| `elastalert.extraVolumes`                    | Additional volume definitions                                                              | []                                   |
| `elastalert.extraVolumeMounts`               | Additional volumeMount definitions                                                         | []                                   |
| `elastalert.resources`                       | Container resource requests and limits                                                     | {}                                   |
| `elastalert.rules`                           | Rule and alert configuration for Elastalert                                                | {} example shown in vars.yml.example |
| `elastalert.runIntervalMins`                 | Default interval between alert checks, in minutes                                          | 1                                    |
| `elastalert.realertIntervalMins`             | Time between alarms for same rule, in minutes                                              | `NULL`                               |
| `elastalert.alertRetryLimitMins`             | Time to retry failed alert deliveries, in minutes                                          | 2880 (2 days)                        |
| `elastalert.bufferTimeMins`                  | Default rule buffer time, in minutes                                                       | 15                                   |
| `elastalert.writebackIndex`                  | Name or prefix of elastalert index(es)                                                     | elastalert_status                    |
| `elastalert.nodeSelector`                    | Node selector for deployment                                                               | {}                                   |
| `elastalert.tolerations`                     | Tolerations for deployment                                                                 | []                                   |
| `elastalert.metrics.enabled`                 | Enable elastalert prometheus endpoint                                                      | `true`                               |
| `elastalert.metrics.port`                    | If "metrics" is set to true, prometheus metrics will be exposed by the pod on this port.   | 9979                                 |
| `elastalert.metrics.serviceMonitor.enabled`  | Enable elastalert prometheus service monitor                                               | `true`                               |
| `elastalert.metrics.serviceMonitor.namespace`| Enable elastalert prometheus service monitor namespace                                     | `prometheus`                         |
| `elastalert.metrics.prometheusRule.enabled`  | Enable elastalert prometheus rules                                                         | `true`                               |
| `praeco.schema`                              | Schema for your Praeco Web GUI, used for link URL in alerts                                | http                                 |
| `praeco.external_host`                       | Host for your Praeco Web GUI                                                               | praeco                               |
| `praeco.port`                                | Port for your Praeco Web GUI                                                               | 8080                                 |

If you have any ploblem, feature-request, please open a github issue.
