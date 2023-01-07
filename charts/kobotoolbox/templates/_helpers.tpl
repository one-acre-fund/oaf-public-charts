{{- define "postgres_host" -}}
{{ tpl .Values.postgresql.auth.host . }}
{{- end -}}

{{- define "kc_dburl" -}}
postgis://{{ .Values.postgresql.auth.username }}:{{ .Values.postgresql.auth.postgresPassword }}@{{ include "postgres_host" . }}:5432/{{ .Values.postgresql.kobocatDatabase }}
{{- end -}}

{{- define "kpi_dburl" -}}
postgis://{{ .Values.postgresql.auth.username }}:{{ .Values.postgresql.auth.postgresPassword }}@{{ include "postgres_host" . }}:5432/{{ .Values.postgresql.kpiDatabase }}
{{- end -}}

{{- define "mongo_db_url" -}}
{{ printf "mongodb://%s:%s@%s:%s/%s" .Values.mongodb.auth.username .Values.mongodb.auth.password (print .Release.Name "-mongodb") "27017" .Values.mongodb.auth.database }}
{{- end -}}

{{- define "internal_domain" -}}
kobo.local
{{- end -}}

{{- define "boolean2str" -}}
{{ . | ternary "True" "False" }}
{{- end -}}

# TODO... define external port only if non-standard 80/443
{{- define "external_port" -}}
{{- end -}}

{{- define "kpi_url" -}}
{{ .Values.general.externalScheme }}://{{ .Values.kpi.subdomain }}.{{ .Values.general.externalDomain }}{{ include "external_port" . }}
{{- end -}}

{{- define "kobocat_url" -}}
{{ .Values.general.externalScheme }}://{{ .Values.kobocat.subdomain }}.{{ .Values.general.externalDomain }}{{ include "external_port" . }}
{{- end -}}

{{- define "enketo_url" -}}
{{ .Values.general.externalScheme }}://{{ .Values.enketo.subdomain }}.{{ .Values.general.externalDomain }}{{ include "external_port" . }}
{{- end -}}

{{- define "redis_url_session" -}}
redis://:{{ .Values.global.redis.password }}@{{ .Release.Name }}-rediscache-master:6379/2
{{- end -}}

{{- define "redis_url_lock" -}}
redis://:{{ .Values.global.redis.password }}@{{ .Release.Name }}-rediscache-master:6379/3
{{- end -}}

{{- define "redis_url_cache" -}}
redis://:{{ .Values.global.redis.password }}@{{ .Release.Name }}-rediscache-master:6379/5
{{- end -}}

{{- define "redis_url_kobobroker" -}}
redis://:{{ .Values.global.redis.password }}@{{ .Release.Name }}-redismain-master:6379/2
{{- end -}}

{{- define "redis_url_kpibroker" -}}
redis://:{{ .Values.global.redis.password }}@{{ .Release.Name }}-redismain-master:6379/1
{{- end -}}

{{- define "mongo_url" -}}
mongodb://{{ .Values.mongodb.auth.username }}:{{ .Values.mongodb.auth.password }}@{{ .Release.Name }}-mongodb:27017
{{- end -}}

{{- define "env_general" -}}
# Choose between http or https
- name: PUBLIC_REQUEST_SCHEME
  value: {{ .Values.general.externalScheme | quote }}
# The publicly-accessible domain where your KoBo Toolbox instance will be reached (e.g. example.com).
- name: PUBLIC_DOMAIN_NAME
  value: {{ .Values.general.externalDomain }}
- name: SESSION_COOKIE_DOMAIN
  value: ".{{ .Values.general.externalDomain }}"
# The private domain used in docker network. Useful for communication between containers without passing through
# a load balancer. No need to be resolved by a public DNS.
- name: INTERNAL_DOMAIN_NAME
  value: {{ include "internal_domain" . }}
# The publicly-accessible subdomain for the KoBoForm form building and management interface (e.g. koboform).
- name: KOBOFORM_PUBLIC_SUBDOMAIN
  value: {{ .Values.kpi.subdomain }}
# The publicly-accessible subdomain for the KoBoCAT data collection and project management interface (e.g.kobocat).
- name: KOBOCAT_PUBLIC_SUBDOMAIN
  value: {{ .Values.kobocat.subdomain }}
# The publicly-accessible subdomain for the Enketo Express web forms (e.g. enketo).
- name: ENKETO_EXPRESS_PUBLIC_SUBDOMAIN
  value: {{ .Values.enketo.subdomain }}
# The initial superuser's username.
- name: KOBO_SUPERUSER_USERNAME
  value: {{ .Values.general.superUser.username | quote }}
# The e-mail address where your users can contact you.
- name: KOBO_SUPPORT_EMAIL
  value: {{ .Values.general.supportEmail | quote }}
- name: DJANGO_ALLOWED_HOSTS
  value: ".{{ .Values.general.externalDomain }} .{{ include "internal_domain" . }} localhost"
- name: SENTRY_ENVIRONMENT
  value: {{ .Values.general.sentry.environment }}
{{- end -}}

{{- define "env_mongo" -}}
- name: KOBO_MONGO_PORT
  value: '27017'
- name: KOBO_MONGO_HOST
  value: {{ .Release.Name }}-mongodb
- name: MONGO_INITDB_ROOT_USERNAME
  value: root
- name: MONGO_INITDB_DATABASE
  value: {{ .Values.mongodb.auth.database | quote }}
- name: MONGO_DB_NAME
  value: {{ .Values.mongodb.auth.database | quote }}
- name: KOBO_MONGO_USERNAME
  value: {{ .Values.mongodb.auth.username | quote }}
{{- end -}}

{{- define "env_postgres" -}}
- name: POSTGRES_PORT
  value: '5432'
- name: POSTGRES_HOST
  value: {{ include "postgres_host" . | quote }}
- name: POSTGRES_USER
  value: {{ .Values.postgresql.auth.username | quote }}
- name: KC_POSTGRES_DB
  value: {{ .Values.postgresql.kobocatDatabase | quote }}
- name: KPI_POSTGRES_DB
  value: {{ .Values.postgresql.kpiDatabase | quote }}
{{- end -}}

{{- define "env_enketo" -}}
- name: ENKETO_REDIS_MAIN_HOST
  value: {{ .Release.Name }}-redismain-master
- name: ENKETO_REDIS_CACHE_HOST
  value: {{ .Release.Name }}-rediscache-master
- name: ENKETO_LINKED_FORM_AND_DATA_SERVER_SERVER_URL
  value: "{{ .Values.kobocat.subdomain }}.{{ .Values.general.externalDomain }}"
- name: ENKETO_LINKED_FORM_AND_DATA_SERVER_API_KEY
  value: {{ .Values.enketo.apiKey | quote }}
- name: ENKETO_SUPPORT_EMAIL
  value: {{ .Values.general.supportEmail }}
{{- end -}}

{{- define "env_externals" -}}
- name: GOOGLE_ANALYTICS_TOKEN
  value: {{ .Values.external.google.analyticsToken | quote }}
- name: KOBOCAT_RAVEN_DSN
  value: {{ .Values.external.ravenDSN.kobocat | quote }}
- name: KPI_RAVEN_DSN
  value: {{ .Values.external.ravenDSN.kpi | quote }}
- name: KPI_RAVEN_JS_DSN
  value: {{ .Values.external.ravenDSN.kpiJs | quote }}
{{- end -}}

{{- define "env_kobocat" -}}
- name: KOBOCAT_DJANGO_DEBUG
  value: {{ include "boolean2str" .Values.general.debug | quote }}
- name: TEMPLATE_DEBUG
  value: {{ include "boolean2str" .Values.general.debug | quote }}
- name: KOBOFORM_URL
  value: {{ include "kpi_url" . | quote }}
- name: KOBOFORM_INTERNAL_URL
  value: "http://{{ .Values.kpi.subdomain }}.{{ include "internal_domain" . }}"
- name: KOBOCAT_URL
  value: {{ include "kobocat_url" . | quote }}
- name: ENKETO_URL
  value: {{ include "enketo_url" . | quote }}
- name: POSTGRES_DB
  value: {{ .Values.postgresql.kobocatDatabase | quote }}
- name: KPI_INTERNAL_URL
  value: "http://{{ .Values.kpi.subdomain }}.{{ include "internal_domain" . }}"
- name: DJANGO_DEBUG
  value: {{ include "boolean2str" .Values.general.debug | quote }}
- name: RAVEN_DSN
  value: {{ .Values.external.ravenDSN.kobocat | quote }}
{{- end -}}

{{- define "env_kpi" -}}
- name: KPI_DJANGO_DEBUG
  value: {{ include "boolean2str" .Values.general.debug | quote }}
- name: TEMPLATE_DEBUG
  value: {{ include "boolean2str" .Values.general.debug | quote }}
- name: KOBOFORM_URL
  value: {{ include "kpi_url" . | quote }}
- name: ENKETO_URL
  value: {{ include "enketo_url" . | quote }}
- name: ENKETO_INTERNAL_URL
  value: "http://{{ .Release.Name }}-enketo:8005"
- name: KOBOCAT_URL
  value: {{ include "kobocat_url" . | quote }}
- name: KOBOCAT_INTERNAL_URL
  value: "http://{{ .Values.kobocat.subdomain }}.{{ include "internal_domain" . }}"
- name: POSTGRES_DB
  value: {{ .Values.postgresql.kpiDatabase | quote }}
# OTHER
- name: DJANGO_DEBUG
  value: {{ include "boolean2str" .Values.general.debug | quote }}
- name: RAVEN_DSN
  value: {{ .Values.external.ravenDSN.kpi | quote }}
- name: RAVEN_JS_DSN
  value: {{ .Values.external.ravenDSN.kpiJs | quote }}
- name: KPI_URL
  value: {{ include "kpi_url" . | quote }}
{{- end -}}

{{- define "env_smtp" -}}
- name: EMAIL_BACKEND
  value: django.core.mail.backends.smtp.EmailBackend
- name: EMAIL_HOST
  value: {{ .Values.smtp.host | quote }}
- name: EMAIL_PORT
  value: {{ .Values.smtp.port | quote }}
- name: EMAIL_HOST_USER
  value: {{ .Values.smtp.user | quote }}
- name: EMAIL_USE_TLS
  value: {{ include "boolean2str" .Values.smtp.tls | quote }}
- name: DEFAULT_FROM_EMAIL
  value: {{ .Values.smtp.from | quote }}
{{- end -}}

# This block is required in both kpi and kobocat servers, so declare it as a reusable block
{{- define "s3-routing" -}}
location ~ ^/protected-s3/(.*)$ {
  # Allow internal requests only, i.e. return a 404 to any client who
  # tries to access this location directly
  internal;
  # Name resolution won't work at all without specifying a resolver here.
  # Configuring a validity period is useful for overriding Amazon's very
  # short (5-second?) TTLs.
  resolver 8.8.8.8 8.8.4.4 valid=300s;
  resolver_timeout 10s;
  # Everything that S3 needs is in the URL; don't pass any headers or
  # body content that the client may have sent
  proxy_pass_request_body off;
  proxy_pass_request_headers off;

  # Stream the response to the client instead of trying to read it all at
  # once, which would potentially use disk space
  proxy_buffering off;

  # Don't leak S3 headers to the client. List retrieved from:
  # https://docs.aws.amazon.com/AmazonS3/latest/API/RESTCommonResponseHeaders.html
  proxy_hide_header x-amz-delete-marker;
  proxy_hide_header x-amz-id-2;
  proxy_hide_header x-amz-request-id;
  proxy_hide_header x-amz-version-id;

  # S3 will complain if `$1` contains non-encoded special characters.
  # KoBoCAT must encode twice to make sure `$1` is still encoded after
  # NGINX's automatic URL decoding.
  proxy_pass $1;
}
{{- end -}}

{{- define "nginx_conf" -}}
charset     utf-8;
gzip on;
gzip_disable "msie6";

# Default configuration
server {
  listen 80 default_server;
  listen [::]:80 default_server;
  # Make sure we use the k8s resolver and not nginx custom logic
  # Disabling ipv6 due to https://stackoverflow.com/questions/66386139/nginx-forward-proxy-config-is-causing-upstream-server-temporarily-disabled-whil
  resolver 127.0.0.1 ipv6=off;

  root /var/www/html;

  # Add index.php to the list if you are using PHP
  index index.html index.htm index.nginx-debian.html;

  server_name $hostname;

  location / {
    # return empty response
    return 204;
  }

  # Proxy ELB status
  location ~ /elb/([^/]*)/(.*)$ {
    proxy_pass http://127.0.0.1/$2;
    proxy_set_header Host $1;
    proxy_intercept_errors on;
    access_log  off;
  }
}

# KoBoCAT HTTP.
server {
  listen      80;
  server_name {{ .Values.kobocat.subdomain }}.{{ include "internal_domain" . }} {{ .Values.kobocat.subdomain }}.docker.internal {{ .Values.kobocat.subdomain }}.{{ .Values.general.externalDomain }};

  # Allow 100M upload
  client_max_body_size 100M;
  # Support bigger headers. Useful for huge cookies
  large_client_header_buffers 8 16k;

  location / {
    uwsgi_read_timeout 130;
    uwsgi_send_timeout 130;
    uwsgi_pass 127.0.0.1:8001;
    # For setting HTTP headers, see http://stackoverflow.com/a/14133533/1877326.
    uwsgi_param HTTP_X_REAL_IP $remote_addr;
    uwsgi_param HTTP_X_FORWARDED_FOR $remote_addr;
    # uwsgi_param HTTP_X_FORWARDED_PROTO $scheme;
    include /etc/nginx/uwsgi_params;

    # Support longer query strings. See issue #147
    uwsgi_buffers 8 16k;
    uwsgi_buffer_size 16k;
  }

  location /static {
    alias /srv/www/kobocat;
  }

  # media files
  location /protected/ {
    internal;
    alias /media/;
  }

  {{- include "s3-routing" . | nindent 2 }}
}

# KoBoForm HTTP.
server {
  listen      80;
  server_name {{ .Values.kpi.subdomain }}.{{ include "internal_domain" . }} {{ .Values.kpi.subdomain }}.docker.internal {{ .Values.kpi.subdomain }}.{{ .Values.general.externalDomain }};

  # Allow 100M upload
  client_max_body_size 100M;
  # Support bigger headers. Useful for huge cookies
  large_client_header_buffers 8 16k;

  location ~ ^/forms/(.*) {
    return 301 /$1;
  }

  location /static {
    alias /srv/www/kpi;

    # gzip configs from here
    # http://stackoverflow.com/a/12644530/3088435
    gzip on;
    gzip_disable "msie6";
    gzip_comp_level 6;
    gzip_min_length 1100;
    gzip_buffers 16 8k;
    gzip_proxied any;
    gzip_types
      text/plain
      text/css
      text/js
      text/xml
      text/javascript
      application/javascript
      application/x-javascript
      application/json
      application/xml
      application/xml+rss;
  }

  # public media, e.g. custom logos (KPI `ConfigurationFile`s)
  location /media/__public {
      alias /srv/kpi_media/__public;
  }

  error_page 418 = /static/html/Offline.html;

  location / {
    uwsgi_read_timeout 130;
    uwsgi_send_timeout 130;
    uwsgi_pass 127.0.0.1:8003;
    # For setting HTTP headers, see http://stackoverflow.com/a/14133533/1877326.
    uwsgi_param HTTP_X_REAL_IP $remote_addr;
    uwsgi_param HTTP_X_FORWARDED_FOR $remote_addr;
    # uwsgi_param HTTP_X_FORWARDED_PROTO $scheme;
    include /etc/nginx/uwsgi_params;

    # Support longer query strings. See issue #147
    uwsgi_buffers 8 16k;
    uwsgi_buffer_size 16k;
  }

  {{- include "s3-routing" . | nindent 2 }}
}
{{- end -}}
