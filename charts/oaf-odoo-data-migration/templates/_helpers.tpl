{{/*
Expand the name of the chart.
*/}}
{{- define "oaf-odoo-data-migration.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "oaf-odoo-data-migration.fullname" -}}
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
{{- define "oaf-odoo-data-migration.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "oaf-odoo-data-migration.labels" -}}
helm.sh/chart: {{ include "oaf-odoo-data-migration.chart" . }}
{{ include "oaf-odoo-data-migration.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "oaf-odoo-data-migration.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oaf-odoo-data-migration.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "oaf-odoo-data-migration.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "oaf-odoo-data-migration.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create environment variables for Odoo connection
*/}}
{{- define "oaf-odoo-data-migration.odooEnvVars" -}}
{{- if .Values.odoo.useSecret }}
- name: ODOO_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "oaf-odoo-data-migration.fullname" . }}-secrets
      key: odoo-url
- name: ODOO_DB
  valueFrom:
    secretKeyRef:
      name: {{ include "oaf-odoo-data-migration.fullname" . }}-secrets
      key: odoo-database
- name: ODOO_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ include "oaf-odoo-data-migration.fullname" . }}-secrets
      key: odoo-username
- name: ODOO_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "oaf-odoo-data-migration.fullname" . }}-secrets
      key: odoo-password
{{- else }}
- name: ODOO_URL
  value: {{ .Values.odoo.url | quote }}
- name: ODOO_DB
  value: {{ .Values.odoo.database | quote }}
- name: ODOO_USERNAME
  value: {{ .Values.odoo.username | quote }}
- name: ODOO_PASSWORD
  value: {{ .Values.odoo.password | quote }}
{{- end }}
{{- end }}
