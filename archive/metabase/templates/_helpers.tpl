{{- define "secrets" -}}
db-password: {{ .Values.postgresql.postgresqlPassword | b64enc }}
{{- end -}}

{{- define "dbHost" -}}
{{ coalesce .Values.postgresql.host ( print .Release.Name "-postgresql." .Release.Namespace ".svc" ) }}
{{- end -}}

{{- define "dbUrl" -}}
{{ printf "postgresql://%s:%s@%s:%s/%s" .Values.postgresql.postgresqlUsername .Values.postgresql.postgresqlPassword (include "dbHost" .) ( toString .Values.postgresql.service.port ) .Values.postgresql.postgresqlDatabase }}
{{- end -}}
