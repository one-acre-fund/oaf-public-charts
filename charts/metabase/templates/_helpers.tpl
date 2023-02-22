{{- define "secrets" -}}
db-password: {{ .Values.postgresql.auth.password | b64enc }}
{{- end -}}

{{- define "dbHost" -}}
{{ coalesce .Values.postgresql.host ( print .Release.Name "-postgresql." .Release.Namespace ".svc" ) }}
{{- end -}}

{{- define "dbUrl" -}}
{{ printf "postgresql://%s:%s@%s:%s/%s" .Values.postgresql.auth.username .Values.postgresql.auth.password (include "dbHost" .) ( toString .Values.postgresql.service.port ) .Values.postgresql.auth.database }}
{{- end -}}
