{{/* vim: set filetype=mustache: */}}

{{- define "compute.provisioner.frontendService" -}}
{{- printf "%s.%s.svc:7777" (include "compute.provisioner.fullname" .) $.Release.Namespace -}}
{{- end -}}

{{- define "compute.provisioner.backendService" -}}
{{- printf "%s.%s.svc:7778" (include "compute.provisioner.fullname" .) $.Release.Namespace -}}
{{- end -}}

{{- define "compute.backendService" -}}
{{- printf "%s.%s.svc:7778" (include "compute.backend.fullname" .) $.Release.Namespace -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "compute.name" -}}
{{- printf "%s" (default .Chart.Name .Values.nameOverride) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "compute.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create unified labels
*/}}
{{- define "compute.common.matchLabels" -}}
app: {{ template "compute.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "compute.common.metaLabels" -}}
chart: {{ template "compute.chart" . }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "compute.common.labels" -}}
{{ include "compute.common.matchLabels" . }}
{{ include "compute.common.metaLabels" . }}
{{- end -}}

{{- define "compute.backend.labels" -}}
{{ include "compute.backend.matchLabels" . }}
{{ include "compute.common.metaLabels" . }}
{{- end -}}

{{- define "compute.backend.matchLabels" -}}
component: {{ .Values.backend.name | quote }}
{{ include "compute.common.matchLabels" . }}
{{- end -}}

{{- define "compute.nginx.labels" -}}
{{ include "compute.nginx.matchLabels" . }}
{{ include "compute.common.metaLabels" . }}
{{- end -}}

{{- define "compute.nginx.matchLabels" -}}
component: {{ .Values.nginx.name | quote }}
{{ include "compute.common.matchLabels" . }}
{{- end -}}

{{- define "compute.provisioner.labels" -}}
{{ include "compute.provisioner.matchLabels" . }}
{{ include "compute.common.metaLabels" . }}
{{- end -}}

{{- define "compute.provisioner.matchLabels" -}}
component: {{ .Values.provisioner.name | quote }}
{{ include "compute.common.matchLabels" . }}
{{- end -}}

{{- define "compute.thredds.labels" -}}
{{ include "compute.thredds.matchLabels" . }}
{{ include "compute.common.metaLabels" . }}
{{- end -}}

{{- define "compute.thredds.matchLabels" -}}
component: {{ .Values.thredds.name | quote }}
{{ include "compute.common.matchLabels" . }}
{{- end -}}

{{- define "compute.wps.labels" -}}
{{ include "compute.wps.matchLabels" . }}
{{ include "compute.common.metaLabels" . }}
{{- end -}}

{{- define "compute.wps.matchLabels" -}}
component: {{ .Values.wps.name | quote }}
{{ include "compute.common.matchLabels" . }}
{{- end -}}

{{- define "compute.wps_beat.labels" -}}
{{ include "compute.wps_beat.matchLabels" . }}
{{ include "compute.common.metaLabels" . }}
{{- end -}}

{{- define "compute.wps_beat.matchLabels" -}}
component: "{{ .Values.wps.name }}-beat"
{{ include "compute.common.matchLabels" . }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "compute.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "compute.backend.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name .Values.backend.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "compute.nginx.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name .Values.nginx.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "compute.provisioner.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name .Values.provisioner.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "compute.thredds.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name .Values.thredds.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "compute.wps.fullname" -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name .Values.wps.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "imagePullSecret" }}
{{- with (omit .Values.imagePullSecret "create") }}
{{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}
{{- end }}

{{/*
Redis URL
*/}}

{{- define "redis.url" -}}
{{- printf "redis://:%s@%s-master:%v/0" .Values.redis.password (include "redis.fullname" .) .Values.redis.master.service.port -}}
{{- end -}}

{{/*
External full qualified app names.
*/}}
{{- define "postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "traefik.fullname" -}}
{{- printf "%s-%s" .Release.Name "traefik" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "prometheus-server.fullname" -}}
{{- printf "%s-%s-server" .Release.Name "prometheus" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "prometheus-pushgateway.fullname" -}}
{{- printf "%s-prometheus-pushgateway" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
