{{/*
Expand the name of the chart.
*/}}
{{- define "oafpass.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "oafpass.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "oafpass.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "oafpass.labels" -}}
helm.sh/chart: {{ include "oafpass.chart" . }}
{{ include "oafpass.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "oafpass.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oafpass.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Memcached names and labels. The bundled memcached is a separate Deployment, not
a sidecar, so every Yopass replica reads the same cache.
*/}}
{{- define "oafpass.memcached.fullname" -}}
{{- printf "%s-memcached" (include "oafpass.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "oafpass.memcached.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oafpass.name" . }}-memcached
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "oafpass.memcached.labels" -}}
helm.sh/chart: {{ include "oafpass.chart" . }}
{{ include "oafpass.memcached.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "oafpass.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "oafpass.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the Secret holding the credentials. Either the one this chart renders
or an existing one (an ExternalSecret's target, typically).
*/}}
{{- define "oafpass.secretName" -}}
{{- default (include "oafpass.fullname" .) .Values.secret.name }}
{{- end }}

{{/*
Memcached address Yopass connects to.
*/}}
{{- define "oafpass.memcachedAddress" -}}
{{- if .Values.database.memcached.enabled -}}
{{ include "oafpass.memcached.fullname" . }}:11211
{{- else -}}
{{ required "database.memcachedAddress is required when database.type=memcached and database.memcached.enabled=false" .Values.database.memcachedAddress }}
{{- end -}}
{{- end }}

{{/*
Origin Yopass is reached on, without a trailing slash. Both callback URLs are
derived from it, so it has to be the ingress host.
*/}}
{{- define "oafpass.publicUrl" -}}
{{- trimSuffix "/" .Values.oafpass.publicUrl -}}
{{- end }}

{{/*
oauth2-proxy callback. Explicit value wins; otherwise <publicUrl>/oauth2/callback.
*/}}
{{- define "oafpass.oauth2Proxy.redirectUrl" -}}
{{- if .Values.auth.oauth2Proxy.redirectUrl -}}
{{ .Values.auth.oauth2Proxy.redirectUrl }}
{{- else -}}
{{ printf "%s/oauth2/callback" (required "oafpass.publicUrl or auth.oauth2Proxy.redirectUrl is required when auth.mode=oauth2-proxy" (include "oafpass.publicUrl" .)) }}
{{- end -}}
{{- end }}

{{/*
Yopass' own OIDC callback. Explicit value wins; otherwise <publicUrl>/auth/callback.
*/}}
{{- define "oafpass.oidc.redirectUrl" -}}
{{- if .Values.auth.oidc.redirectUrl -}}
{{ .Values.auth.oidc.redirectUrl }}
{{- else -}}
{{ printf "%s/auth/callback" (required "oafpass.publicUrl or auth.oidc.redirectUrl is required when auth.mode=oidc" (include "oafpass.publicUrl" .)) }}
{{- end -}}
{{- end }}

{{/*
Port the Service sends traffic to: oauth2-proxy when it fronts Yopass,
otherwise Yopass itself.
*/}}
{{- define "oafpass.service.targetPort" -}}
{{- if eq .Values.auth.mode "oauth2-proxy" -}}
oauth2-proxy
{{- else -}}
http
{{- end -}}
{{- end }}

{{/*
Fail early on value combinations that only break at runtime.
*/}}
{{- define "oafpass.validateValues" -}}
{{- if not (has .Values.auth.mode (list "none" "oauth2-proxy" "oidc")) }}
{{- fail (printf "auth.mode must be one of none, oauth2-proxy, oidc — got %q" .Values.auth.mode) }}
{{- end }}
{{- if not (has .Values.database.type (list "memcached" "redis")) }}
{{- fail (printf "database.type must be memcached or redis — got %q" .Values.database.type) }}
{{- end }}
{{- if and (eq .Values.database.type "redis") (not .Values.database.redis.url) (not .Values.database.redis.existingSecret) (not .Values.secret.redisUrl) }}
{{- fail "database.type=redis needs database.redis.url, database.redis.existingSecret or secret.redisUrl" }}
{{- end }}
{{- if and (eq .Values.auth.mode "oidc") (not .Values.auth.oidc.clientId) }}
{{- fail "auth.mode=oidc needs auth.oidc.clientId" }}
{{- end }}
{{/*
Licence-gated settings. Yopass does not degrade for these — it calls
logger.Fatal in validateFlags and the container crash-loops. license.enabled is
the assertion that a key actually reaches the container, which the chart cannot
verify itself when an ExternalSecret owns the Secret.
*/}}
{{- if and (eq .Values.auth.mode "oidc") (not .Values.license.enabled) }}
{{- fail "auth.mode=oidc requires a Yopass licence — set license.enabled=true once a key is delivered (secret.licenseKey or an ExternalSecret), or the server refuses to start" }}
{{- end }}
{{- if and .Values.oafpass.auditLog (not .Values.license.enabled) }}
{{- fail "oafpass.auditLog=true requires a Yopass licence — the server exits with \"--audit-log requires a valid license key\". Set license.enabled=true once a key is delivered, or turn auditLog off" }}
{{- end }}
{{- if and .Values.oafpass.webhookUrl (not .Values.license.enabled) }}
{{- fail "oafpass.webhookUrl requires a Yopass licence — the server exits with \"--webhook-url requires a valid license key\"" }}
{{- end }}
{{- if not (has .Values.oafpass.defaultExpiry (list "1h" "1d" "1w")) }}
{{- fail (printf "oafpass.defaultExpiry must be one of 1h, 1d, 1w — got %q" .Values.oafpass.defaultExpiry) }}
{{- end }}
{{- if not (has .Values.oafpass.forceExpiration (list "" "1h" "1d" "1w")) }}
{{- fail (printf "oafpass.forceExpiration must be empty or one of 1h, 1d, 1w — got %q" .Values.oafpass.forceExpiration) }}
{{- end }}
{{- if and (eq .Values.auth.mode "oauth2-proxy") .Values.secret.create (not .Values.secret.oauth2ProxyCookieSecret) }}
{{- fail "auth.mode=oauth2-proxy with secret.create=true needs secret.oauth2ProxyCookieSecret (16, 24 or 32 bytes)" }}
{{- end }}
{{- end }}
