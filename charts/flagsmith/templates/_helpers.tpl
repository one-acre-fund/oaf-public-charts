{{- define "dbHost" -}}
{{ coalesce .Values.postgresql.host ( print .Release.Name "-postgresql." .Release.Namespace ".svc" ) }}
{{- end -}}

{{- define "dbUrl" -}}
{{ printf "postgresql://%s:%s@%s:%s/%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword (include "dbHost" .) ( toString .Values.postgresql.service.port ) .Values.postgresql.postgresqlDatabase }}
{{- end -}}

{{- define "apiHost" -}}
{{ .Release.Name }}-api.{{ .Release.Namespace }}.svc
{{- end -}}

{{- define "fullUrl" -}}
{{ .scheme }}://{{ .domain }}{{ if .port }}:{{ .port }}{{ end }}
{{- end -}}

{{- define "api_secrets" -}}
DJANGO_DB_PASSWORD: {{ .Values.postgresql.postgresqlPassword | b64enc }}
DATABASE_URL: {{ include "dbUrl" . | b64enc }}
ADMIN_INITIAL_PASSWORD: {{ .Values.flagsmith.admin.password | b64enc }}
DJANGO_SECRET_KEY: {{ .Values.flagsmith.djangoSecret | b64enc }}
# Custom keys
{{- range $key, $value := .Values.flagsmith.api.extraSecretEnv }}
{{ $key }}: {{ tpl $value $ | b64enc }}
{{- end }}
{{- end -}}

{{- define "frontend_secrets" -}}
{{- range $key, $value := .Values.flagsmith.frontend.extraSecretEnv }}
{{ $key }}: {{ tpl $value $ | b64enc }}
{{- end }}
{{- end -}}
