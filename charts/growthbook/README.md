# growthbook



![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.4-informational?style=flat-square) 

GrowthBook - an open source solution for feature flagging and experimentation platform

**Homepage:** <https://www.growthbook.io//>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| bisonlou | bisonlou@gmail.com |  |
| Yann-J | yann.jouanique@gmail.com |  |
| Nzeugaa | jean.poutcheu@gmail.com |  |

## Source Code

* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/growthbook>

## TL;DR;

```console
$ helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
$ helm install my-release one-acre-fund/growthbook
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mongodb | ~10.26.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| growthbook.nodeEnv | string | `"production"` | Set to "production" to turn on additional optimizations and API request logging |
| growthbook.mongodbUri | string | `"mongodb://root:password@mongo:27017/"` | MongoDB uri |
| growthbook.appOrigin | string | `"https://my-app-origin.io:443"` | Frontend App Origin URL |
| growthbook.apiHost | string | `"https://my-api-host.io:443"` | Backend API URL |
| growthbook.email.enabled | bool | `false` | Email enabled or not in order to send experiment alerts, team member invites, and reset password emails |
| growthbook.email.host | string | `"host.example.com"` | Email SMTP host |
| growthbook.email.port  | int | `25` | Email SMTP port |
| growthbook.email.hostUser  | string | `"user"` | Email SMTP host user |
| growthbook.email.hostPassword | string | `"password"` | Email SMTP host password  |
| growthbook.email.sender | string | see `"sender@example.com"` | Sender email |
| ingress.enabled | bool | `false` | Install ingress? |
| ingress.appOriginName | string | `"my-app-origin.io"` | Frontend App Origin Host |
| ingress.apiHostName| string | `"my-api-host.io"` | Backend API Host |
| replicaCount | int | `1` | Replica count  |
| mongodb.auth.rootUser  | string | `"user"` | MongoDB root user |
| mongodb.auth.rootPassword | string | `"password"` | MongoDB root password  |
| autoscaling.enabled | bool | `false` | Enable Autoscaling?  |
| autoscaling.minReplicas | int | `1` | Autoscaling min replicas  |
| autoscaling.maxReplicas | int | `100` | Autoscaling max replicas  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Autoscaling Target CPU Utilization Percentage |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | Autoscaling Target Memory Utilization Percentage |
| serviceAccount.create | bool | `true` | Create a ServiceAccount? |
| serviceAccount.annotations | object | `{}` | ServiceAccount annotations |
| serviceAccount.name | string | `""` | The name of the service account to use |
| persistence.enabled | bool | `false` | Enable persistence? |
| persistence.type | string | `"emptyDir"` | Persistent volume type, possible options are [existing, emptyDir, dynamic] |
| persistence.storageClassName | string | `""` | Persistent volume storage class name |
| persistence.accessModes[0] | string | `"ReadWriteMany"` | Persistent acces mode |
| persistence.storage | string | `3Gi` | Persistent volume claim storage size |
| persistence.existingClaim | string | `""` | Existing Persistent volume claim to use |