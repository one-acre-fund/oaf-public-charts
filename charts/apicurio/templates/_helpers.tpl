{{ define "secrets_api" -}}
APICURIO_DB_PASSWORD: {{ .Values.postgresql.postgresqlPassword | b64enc }}
APICURIO_KC_CLIENT_SECRET: {{ .Values.keycloak.client.secret | b64enc }}
APICURIO_MICROCKS_CLIENT_SECRET: {{ .Values.microcks.client.secret | b64enc }}
# Extras
{{- range $key, $value := .Values.api.extraSecretEnvVars }}
{{ $key }}: {{- tpl $value $ | b64enc }}
{{- end }}
{{- end }}

{{ define "secrets_ui" -}}
APICURIO_KC_CLIENT_SECRET: {{ .Values.keycloak.client.secret | b64enc }}
APICURIO_MICROCKS_CLIENT_SECRET: {{ .Values.microcks.client.secret | b64enc }}
# Extras
{{- range $key, $value := .Values.ui.extraSecretEnvVars }}
{{ $key }}: {{- tpl $value $ | b64enc }}
{{- end }}
{{- end }}

{{ define "secrets_ws" -}}
APICURIO_DB_PASSWORD: {{ .Values.postgresql.postgresqlPassword | b64enc }}
# Extras
{{- range $key, $value := .Values.ws.extraSecretEnvVars }}
{{ $key }}: {{- tpl $value $ | b64enc }}
{{- end }}
{{- end }}

{{- define "dbHost" -}}
{{ coalesce .Values.postgresql.host ( print .Release.Name "-postgresql" ) }}
{{- end -}}

# TODO: support other db... for H2: "jdbc:h2:mem:apicuriodb"
{{- define "dbUrl" -}}
{{ printf "postgresql://%s:%s@%s:%s/%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword (include "dbHost" .) ( toString .Values.postgresql.service.port ) .Values.postgresql.postgresqlDatabase }}
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
