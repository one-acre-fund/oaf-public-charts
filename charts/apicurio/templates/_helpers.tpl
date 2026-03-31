{{/* ---- Apicurio Studio helpers ---- */}}

{{ define "secrets_api" -}}
APICURIO_DB_PASSWORD: {{ .Values.postgresql.auth.password | b64enc }}
{{- if .Values.keycloak.enabled }}
APICURIO_KC_CLIENT_SECRET: {{ .Values.keycloak.client.secret | b64enc }}
{{- end }}
{{- if .Values.microcks.client.secret }}
APICURIO_MICROCKS_CLIENT_SECRET: {{ .Values.microcks.client.secret | b64enc }}
{{- end }}
# Extras
{{- range $key, $value := .Values.api.extraSecretEnvVars }}
{{ $key }}: {{- tpl $value $ | b64enc }}
{{- end }}
{{- end }}

{{ define "secrets_ui" -}}
{{- if .Values.keycloak.enabled }}
APICURIO_KC_CLIENT_SECRET: {{ .Values.keycloak.client.secret | b64enc }}
QUARKUS_OIDC_CREDENTIALS_SECRET: {{ .Values.keycloak.client.secret | b64enc }}
{{- end }}
{{- if .Values.microcks.client.secret }}
APICURIO_MICROCKS_CLIENT_SECRET: {{ .Values.microcks.client.secret | b64enc }}
{{- end }}
# Extras
{{- range $key, $value := .Values.ui.extraSecretEnvVars }}
{{ $key }}: {{- tpl $value $ | b64enc }}
{{- end }}
{{- end }}

{{ define "secrets_ws" -}}
APICURIO_DB_PASSWORD: {{ .Values.postgresql.auth.password | b64enc }}
# Extras
{{- range $key, $value := .Values.ws.extraSecretEnvVars }}
{{ $key }}: {{- tpl $value $ | b64enc }}
{{- end }}
{{- end }}

{{- define "dbHost" -}}
{{ coalesce .Values.postgresql.host ( print .Release.Name "-postgresql" ) }}
{{- end -}}

{{- define "dbUrl" -}}
{{ printf "jdbc:postgresql://%s:%s/%s" (include "dbHost" .) ( toString .Values.postgresql.service.port ) .Values.postgresql.auth.database }}
{{- end -}}

{{- define "tcpProbe" -}}
tcpSocket:
  port: 8080
initialDelaySeconds: 10
periodSeconds: 5
failureThreshold: 15
{{- end -}}

{{- define "httpProbe" -}}
httpGet:
  path: {{ . | quote }}
  port: 8080
initialDelaySeconds: 10
periodSeconds: 5
failureThreshold: 15
{{- end -}}

{{/* ---- Microcks helpers ---- */}}

{{- define "microcks.fullname" -}}
{{ .Release.Name }}-microcks
{{- end }}

{{- define "microcks.labels" -}}
app: microcks
app.kubernetes.io/managed-by: {{ .Release.Service }}
group: microcks
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{- define "microcks.app.selectorLabels" -}}
app: microcks
container: spring
group: microcks
{{- end }}

{{- define "microcks.app.matchLabels" -}}
app: microcks
container: spring
deploymentconfig: microcks
group: microcks
{{- end }}

{{- define "microcks.mongodb.selectorLabels" -}}
app.kubernetes.io/component: mongodb
app.kubernetes.io/instance: {{ include "microcks.fullname" . }}-mongodb
app.kubernetes.io/name: mongodb
{{- end }}

{{- define "microcks.postman.selectorLabels" -}}
app: microcks
container: postman-runtime
group: microcks
{{- end }}

{{- define "microcks.postman.matchLabels" -}}
app: microcks
container: postman-runtime
deploymentconfig: microcks-postman-runtime
group: microcks
{{- end }}

{{- define "microcks.mongodb.name" -}}
{{ include "microcks.fullname" . }}-mongodb
{{- end }}

{{- define "microcks.postman.name" -}}
{{ include "microcks.fullname" . }}-postman-runtime
{{- end }}

{{- define "microcks.grpc.name" -}}
{{ include "microcks.fullname" . }}-grpc
{{- end }}

{{/*
Resolve the Microcks API URL: explicit value > auto-derived from service name
*/}}
{{- define "microcks.apiUrl" -}}
{{- if .Values.microcks.client.apiUrl -}}
{{ .Values.microcks.client.apiUrl }}
{{- else if .Values.microcks.enabled -}}
http://{{ include "microcks.fullname" . }}:{{ .Values.microcks.app.service.port }}/api
{{- else -}}
http://localhost:8080/api
{{- end -}}
{{- end -}}

{{/*
Resolve the Microcks Keycloak realm (falls back to main keycloak realm)
*/}}
{{- define "microcks.keycloakRealm" -}}
{{ coalesce .Values.microcks.keycloak.realm .Values.keycloak.realm "Apicurio" }}
{{- end -}}

{{/*
Resolve the Postman runner URL
*/}}
{{- define "microcks.postmanUrl" -}}
http://{{ include "microcks.postman.name" . }}:{{ .Values.microcks.postman.service.port }}
{{- end -}}

{{/*
Resolve the Microcks test callback URL
*/}}
{{- define "microcks.callbackUrl" -}}
http://{{ include "microcks.fullname" . }}:{{ .Values.microcks.app.service.port }}
{{- end -}}
