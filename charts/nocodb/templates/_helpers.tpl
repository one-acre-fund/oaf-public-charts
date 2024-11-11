{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}
=

{{- define "nocodb.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "common.names.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "nocodb.name" -}}
{{- if .Values.nameOverride -}}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- include "common.names.name" . -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for Postgresql.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nocodb.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name for Minio.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nocodb.minio.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "minio" "chartValues" .Values.minio "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name for Redis.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nocodb.redis.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $) -}}
{{- end -}}

{{/*
Return the proper nocodb image name
*/}}
{{- define "nocodb.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "nocodb.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the Postgresql hostname
*/}}
{{- define "nocodb.databaseHost" -}}
{{- ternary (include "nocodb.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Return the Postgresql port
*/}}
{{- define "nocodb.databasePort" -}}
{{- ternary 5432 .Values.externalDatabase.port .Values.postgresql.enabled -}}
{{- end -}}

{{/*
Return the Postgresql database name
*/}}
{{- define "nocodb.databaseName" -}}
{{- if .Values.postgresql.enabled }}
    {{- .Values.postgresql.auth.database -}}
{{- else -}}
    {{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql user
*/}}
{{- define "nocodb.databaseUser" -}}
{{- if .Values.postgresql.enabled }}
    {{- .Values.postgresql.auth.username -}}
{{- else -}}
    {{- .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Secret Name
*/}}
{{- define "nocodb.database.secretName" -}}
  {{- if .Values.postgresql.enabled }}
    {{- if .Values.postgresql.auth.existingSecret }}
      {{- tpl .Values.postgresql.auth.existingSecret $ -}}
    {{- else -}}
      {{- default (include "nocodb.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
  {{- else -}}
    {{- default (printf "%s-externaldb" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") (tpl .Values.externalDatabase.existingSecret $) -}}
  {{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "nocodb.database.secretPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- default "password" .Values.postgresql.auth.secretKeys.userPasswordKey -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "nocodb.database.secretPostgresPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- default "postgres-password" .Values.postgresql.auth.secretKeys.postgresPasswordKey -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPostgresPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPostgresPasswordKey -}}
        {{- else -}}
            {{- print "postgres-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "postgres-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "nocodb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "nocodb.admin.secretName" -}}
  {{- if .Values.admin.existingSecret -}}
    {{- printf "%s" .Values.admin.existingSecret -}}
  {{- else -}}
    {{- printf "%s-supper-admin-secret" (include "nocodb.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "nocodb.admin.emailKey" -}}
    {{- if .Values.admin.existingSecretEmailKey -}}
        {{- printf "%s" .Values.admin.existingSecretEmailKey -}}
    {{- else -}}
        {{- print "email" -}}
    {{- end -}}
{{- end -}}

{{- define "nocodb.admin.passwordKey" -}}
    {{- if .Values.admin.existingSecretPasswordKey -}}
        {{- printf "%s" .Values.admin.existingSecretPasswordKey -}}
    {{- else -}}
        {{- print "password" -}}
    {{- end -}}
{{- end -}}

{{- define "nocodb.smtp.secretName" -}}
  {{- if .Values.smtp.existingSecret -}}
    {{- printf "%s" .Values.smtp.existingSecret -}}
  {{- else -}}
    {{- printf "%s-smtp-secret" (include "nocodb.fullname" .) -}}
  {{- end -}}
{{- end -}}

{{- define "nocodb.smtp.secretPasswordKey" -}}
    {{- if .Values.smtp.existingSecretPasswordKey -}}
        {{- printf "%s" .Values.smtp.existingSecretPasswordKey -}}
    {{- else -}}
        {{- print "smtp-password" -}}
    {{- end -}}
{{- end -}}

{{- define "nocodb.smtp.secretUsernameKey" -}}
    {{- if .Values.smtp.existingSecretUsernameKey -}}
        {{- printf "%s" .Values.smtp.existingSecretUsernameKey -}}
    {{- else -}}
        {{- print "smtp-username" -}}
    {{- end -}}
{{- end -}}

{{/*
Get the credentials secret.
*/}}
{{- define "nocodb.minio.secretName" -}}
{{- if .Values.minio.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.minio.auth.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "nocodb.minio.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "nocodb.minio.rootUserKey" -}}
    {{- if .Values.minio.auth.rootUserSecretKey -}}
        {{- printf "%s" .Values.minio.auth.rootUserSecretKey -}}
    {{- else -}}
        {{- print "root-user" -}}
    {{- end -}}
{{- end -}}

{{- define "nocodb.minio.rootPasswordKey" -}}
    {{- if .Values.minio.auth.rootPasswordSecretKey -}}
        {{- printf "%s" .Values.minio.auth.rootPasswordSecretKey -}}
    {{- else -}}
        {{- print "root-password" -}}
    {{- end -}}
{{- end -}}

{{- define "nocodb.minio.endpoint" -}}
{{- if .Values.minio.enabled -}}
http://{{ include "nocodb.minio.fullname" . }}:{{ .Values.minio.containerPorts.api }}
{{- else if .Values.externalMinio.create -}}
{{ .Values.externalMinio.endpoint | quote }}
{{- end -}}
{{- end -}}

{{- define "nocodb.minio.region" -}}
{{- if .Values.minio.enabled -}}
{{ .Values.minio.region | quote }}
{{- else if .Values.externalMinio.create -}}
{{ .Values.externalMinio.region | quote }}
{{- end -}}
{{- end -}}

{{- define "nocodb.minio.bucketName" -}}
{{- if .Values.minio.enabled -}}
{{ include "nocodb.fullname" . | quote }}
{{- else if .Values.externalMinio.create -}}
{{ .Values.externalMinio.bucketName | quote }}
{{- end -}}
{{- end -}}

{{- define "nocodb.redis.secretName" -}}
{{- if .Values.redis.auth.existingSecret -}}
    {{- printf "%s" (tpl .Values.redis.auth.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "nocodb.redis.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "nocodb.redis.passwordKey" -}}
    {{- if .Values.redis.auth.existingSecretKey -}}
        {{- printf "%s" .Values.redis.auth.existingSecretKey -}}
    {{- else -}}
        {{- print "redis-password" -}}
    {{- end -}}
{{- end -}}
