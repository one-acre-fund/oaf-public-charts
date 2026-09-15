# oafpass

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 14.9.0](https://img.shields.io/badge/AppVersion-14.9.0-informational?style=flat-square)

oafpass — One Acre Fund's branded Yopass deployment for client-side encrypted secret sharing, with optional Google sign-in in front of it

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| ajimoh-oaf | <jimoh.abdullah69@gmail.com> | <https://github.com/ajimoh-oaf> |

## Source Code

* <https://github.com/jhaals/yopass>
* <https://github.com/one-acre-fund/oaf-public-charts/tree/main/charts/oafpass>

## TL;DR

[Yopass](https://yopass.se) shares secrets through one-time links. The message is
encrypted in the browser and the key never leaves the fragment of the URL, so the
server stores ciphertext it cannot read. This chart deploys it under One Acre
Fund's `oafpass` branding, with a storage backend and an optional Google login
in front.

```console
helm repo add one-acre-fund https://one-acre-fund.github.io/oaf-public-charts
helm install oafpass one-acre-fund/oafpass
```

## Sign-in

`auth.mode` picks one of three:

| `auth.mode` | What it does | Licence |
|-------------|--------------|---------|
| `none` | Anyone who reaches the ingress can create and read secrets. | — |
| `oauth2-proxy` | An [oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/) sidecar fronts Yopass. **Every** request — creating a secret and opening one — needs a Google login from an allowed domain. | none |
| `oidc` | Yopass' own OIDC. Only secret *creation* is gated; recipients open links without an account. | **a paid Yopass licence key** — the server refuses to start with OIDC configured and no licence |

Both authenticated modes need a Google OAuth 2.0 client (APIs & Services →
Credentials → OAuth client ID → Web application) with the callback registered
verbatim, or Google answers `redirect_uri_mismatch`:

* `oauth2-proxy` → `https://<host>/oauth2/callback`
* `oidc` → `https://<host>/auth/callback`

`oafpass.publicUrl` is where both are derived from, so set it to the ingress
host. It is also what Yopass builds the copied secret links out of.

### oauth2-proxy quick setup

```yaml
auth:
  mode: oauth2-proxy
  oauth2Proxy:
    emailDomains:
      - oneacrefund.org      # do not leave this at "*"
oafpass:
  publicUrl: https://oafpass.oneacrefund.org
secret:
  oauth2ProxyClientId: "<client id>.apps.googleusercontent.com"
  oauth2ProxyClientSecret: "GOCSPX-..."
  # openssl rand -base64 32 | tr -- '+/' '-_'
  oauth2ProxyCookieSecret: "..."
```

Because oauth2-proxy gates reads as well as writes, a link shared with someone
outside the allowed domains will not open. That is the trade-off for not needing
a licence; `oidc` is the mode that keeps reads public.

## Secrets

Everything credential-shaped lives in one Secret so a cluster can hand the whole
thing to [External Secrets](https://external-secrets.io/) instead of git:

```yaml
secret:
  create: false            # nothing rendered from values
  name: oafpass            # an ExternalSecret owns a Secret of this name
```

The container wiring is identical either way. `secretKeys.*` renames the keys if
an existing Secret spells them differently.

## Storage

Yopass exits at startup without a backend.

* `database.type=memcached` (default) deploys a single bundled memcached. It is
  in-memory only: secrets still in flight are lost when that pod restarts. For
  short-lived one-time links that is usually the right trade-off.
* `database.type=redis` points at an external Redis via `database.redis.url`,
  or at a Secret key when the URL carries a password.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules for the pods. |
| auth.mode | string | `"none"` | Sign-in mode: `none`, `oauth2-proxy` or `oidc`. |
| auth.oauth2Proxy.cookieExpire | string | `"168h"` | Session cookie lifetime (`--cookie-expire`). |
| auth.oauth2Proxy.cookieRefresh | string | `"1h"` | How often the session is refreshed against the provider (`--cookie-refresh`). Must be shorter than `cookieExpire`. |
| auth.oauth2Proxy.cookieSecure | bool | `true` | Only send the session cookie over HTTPS (`--cookie-secure`). |
| auth.oauth2Proxy.emailDomains | list | `["*"]` | Email domains allowed to sign in (`--email-domain`). `["*"]` allows any account that completes the Google login — set your own domain instead. |
| auth.oauth2Proxy.extraArgs | list | `[]` | Extra args for oauth2-proxy. |
| auth.oauth2Proxy.extraEnv | object | `{}` | Extra environment variables for oauth2-proxy. |
| auth.oauth2Proxy.image.pullPolicy | string | `"IfNotPresent"` | oauth2-proxy image pull policy. |
| auth.oauth2Proxy.image.repository | string | `"quay.io/oauth2-proxy/oauth2-proxy"` | oauth2-proxy image repository. |
| auth.oauth2Proxy.image.tag | string | `"v7.7.1"` | oauth2-proxy image tag. |
| auth.oauth2Proxy.port | int | `4180` | Port the sidecar listens on. The Service targets this port in this mode. |
| auth.oauth2Proxy.provider | string | `"google"` | Identity provider (`--provider`). `google` for Google Workspace. |
| auth.oauth2Proxy.redirectUrl | string | `""` | Full callback URL registered with the provider (`--redirect-url`). Must be `https://<host>/oauth2/callback`. Derived from `oafpass.publicUrl` when empty. |
| auth.oauth2Proxy.resources | object | `{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"25m","memory":"64Mi"}}` | Resources for the oauth2-proxy container. |
| auth.oauth2Proxy.skipAuthRoutes | list | `["^/health$","^/ready$"]` | Paths served without a login, as regexes (`--skip-auth-route`). The health endpoints are here so kubelet probes and uptime checks do not get bounced to Google. |
| auth.oauth2Proxy.skipProviderButton | bool | `true` | Skip the "Sign in with Google" interstitial and redirect straight to the provider (`--skip-provider-button`). |
| auth.oidc.allowedDomains | string | `""` | Comma-separated email domains allowed to sign in (`--oidc-allowed-domains`). |
| auth.oidc.clientId | string | `""` | OAuth2 client ID (`--oidc-client-id`). |
| auth.oidc.issuer | string | `"https://accounts.google.com"` | Issuer URL (`--oidc-issuer`). `https://accounts.google.com` for Google. |
| auth.oidc.redirectUrl | string | `""` | Callback URL (`--oidc-redirect-url`). Must be `https://<host>/auth/callback`. Derived from `oafpass.publicUrl` when empty. |
| auth.oidc.requireAuth | bool | `true` | Refuse to create secrets without a login (`--require-auth`). Reading stays open either way. |
| autoscaling.enabled | bool | `false` | Deploy a HorizontalPodAutoscaler. |
| autoscaling.maxReplicas | int | `5` | Maximum replicas. |
| autoscaling.minReplicas | int | `1` | Minimum replicas. |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target average CPU utilisation. |
| autoscaling.targetMemoryUtilizationPercentage | string | `""` | Target average memory utilisation. |
| branding.appName | string | `"oafpass"` | Product name shown in the UI and page title (`--app-name`). |
| branding.logoUrl | string | `""` | URL of a logo served in the header (`--logo-url`). |
| branding.themeDark | string | `""` | Built-in dark theme (`--theme-dark`), e.g. `dim`. |
| branding.themeLight | string | `""` | Built-in light theme (`--theme-light`), e.g. `emerald`. |
| database.memcached.enabled | bool | `true` | Deploy the bundled single-replica memcached. Turn it off to point at `database.memcachedAddress` instead. |
| database.memcached.extraArgs | list | `[]` | Extra args for the memcached container. |
| database.memcached.image.pullPolicy | string | `"IfNotPresent"` | Memcached image pull policy. |
| database.memcached.image.repository | string | `"memcached"` | Memcached image repository. |
| database.memcached.image.tag | string | `"1.6-alpine"` | Memcached image tag. |
| database.memcached.memoryLimitMb | int | `64` | Memcached cache size in MiB (`-m`). This is the ceiling on all live secrets at once; memcached evicts the oldest when it fills. |
| database.memcached.resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"25m","memory":"96Mi"}}` | Resources for the memcached container. |
| database.memcachedAddress | string | `""` | Memcached address used when `database.memcached.enabled=false` (`--memcached`). |
| database.redis.existingSecret | string | `""` | Read the URL from a Secret key instead, so a password in the URL stays out of git. Defaults to the chart Secret (see `secret`) when empty. |
| database.redis.existingSecretUrlKey | string | `"redis-url"` | Key holding the Redis URL in that Secret. |
| database.redis.url | string | `""` | Redis connection URL (`--redis`), e.g. `redis://redis.tools:6379/0`. Only read when `database.type=redis`. |
| database.type | string | `"memcached"` | Backend type: `memcached` or `redis` (`--database`). |
| extraArgs | list | `[]` | Extra flags for the Yopass server, e.g. `["--file-store=s3"]`. |
| extraEnv | object | `{}` | Extra environment variables for the Yopass container. |
| extraEnvFrom | list | `[]` | Extra environment variables sourced from existing ConfigMaps/Secrets. |
| extraVolumeMounts | list | `[]` | Extra volume mounts on the Yopass container. |
| extraVolumes | list | `[]` | Extra volumes on the Deployment. |
| fullnameOverride | string | `""` | Override the full resource name prefix (usually `<release>-<chart>`). |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy. |
| image.repository | string | `"jhaals/yopass"` | Yopass image repository. |
| image.tag | string | `""` | Image tag. Defaults to the chart appVersion when empty. |
| imagePullSecrets | list | `[]` | Image pull secrets for the Yopass and sidecar images. |
| ingress.annotations | object | `{}` | Annotations for the Ingress. |
| ingress.className | string | `""` | `ingressClassName` of the Ingress. |
| ingress.enabled | bool | `false` | Deploy an Ingress for Yopass. |
| ingress.hosts | list | `[{"host":"oafpass.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress hosts and paths. |
| ingress.tls | list | `[]` | Ingress TLS configuration. |
| license.key | string | `""` | Yopass licence key, required by `auth.mode=oidc`. Prefer delivering it through the Secret (`secret.licenseKey`) rather than here. |
| livenessProbe | object | `{"httpGet":{"path":"/health","port":"http"},"initialDelaySeconds":10,"periodSeconds":20}` | Liveness probe for the Yopass container. Probes hit Yopass directly, not through oauth2-proxy. |
| nameOverride | string | `""` | Override the chart name used in resource names. |
| nodeSelector | object | `{}` | Node selector for the pods. |
| oafpass.argon2 | bool | `false` | Use Argon2id for password key derivation (`--argon2`). Slower, stronger. |
| oafpass.auditLog | bool | `false` | Emit structured audit log lines for every secret operation (`--audit-log`). Goes to stdout unless `auditLogFile` is set. |
| oafpass.auditLogFile | string | `""` | Write the audit log to this path instead of stdout (`--audit-log-file`). Needs a writable volume — see `extraVolumes` / `extraVolumeMounts`. |
| oafpass.corsAllowOrigin | string | `""` | `CORS` allow-origin header (`--cors-allow-origin`). Chart default is the public URL only; set `"*"` to restore the upstream default. |
| oafpass.defaultExpiry | string | `"1h"` | Default expiry offered in the UI (`--default-expiry`). Yopass accepts `1h`, `1d` or `1w` and rejects anything else at startup. |
| oafpass.disableSecretRequests | bool | `false` | Disable the secret-request feature (`--disable-secret-requests`). |
| oafpass.disableUpload | bool | `false` | Disable file uploads (`--disable-upload`). |
| oafpass.forceExpiration | string | `""` | Cap every secret at this expiry, overriding the user's choice (`--force-expiration`). One of `1h`, `1d`, `1w`. Empty leaves the user's choice alone. |
| oafpass.forceOnetimeSecrets | bool | `false` | Force every secret to be one-time only (`--force-onetime-secrets`). |
| oafpass.imprintUrl | string | `""` | URL of an imprint linked in the footer (`--imprint-url`). |
| oafpass.logLevel | string | `"info"` | Log level: `debug`, `info`, `warn` or `error` (`--log-level`). |
| oafpass.maxFileSize | string | `"512KB"` | Maximum upload size (`--max-file-size`). Ignored when uploads are off. |
| oafpass.maxLength | int | `10000` | Maximum secret length in characters (`--max-length`). |
| oafpass.metricsPort | int | `-1` | Prometheus metrics port (`--metrics-port`). `-1` disables metrics. |
| oafpass.noLanguageSwitcher | bool | `false` | Hide the language switcher (`--no-language-switcher`). |
| oafpass.privacyNoticeUrl | string | `""` | URL of a privacy notice linked in the footer (`--privacy-notice-url`). |
| oafpass.publicUrl | string | `""` | Public URL Yopass builds secret links with (`--public-url`). Set this to the ingress host or copied links point at the wrong origin. |
| oafpass.readOnly | bool | `false` | Serve the UI read-only: existing secrets can be opened, no new ones created (`--read-only`). |
| oafpass.trustedProxies | string | `""` | Comma-separated CIDRs whose `X-Forwarded-For` Yopass trusts (`--trusted-proxies`). Set it when the client IP matters in the audit log. |
| podAnnotations | object | `{}` | Extra annotations for the Yopass pods. |
| podLabels | object | `{}` | Extra labels for the Yopass pods. |
| podSecurityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` | Pod-level security context. |
| readinessProbe | object | `{"httpGet":{"path":"/ready","port":"http"},"initialDelaySeconds":5,"periodSeconds":10}` | Readiness probe for the Yopass container. |
| replicaCount | int | `1` | Number of Yopass replicas. With the bundled in-cluster memcached this can safely be raised; with `database.memcached.enabled=false` and a shared backend it can be raised too. Sessions are the only sticky part — see `auth.oidc.sessionKey` / `auth.oauth2Proxy`. |
| resources | object | `{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}` | Resources for the Yopass container. |
| secret.apiToken | string | `""` | Static bearer token for API clients (`--api-token`). Optional. |
| secret.create | bool | `true` | Render the Secret from the values below. `false` expects a Secret named `secret.name` (or the chart fullname) to already exist. |
| secret.licenseKey | string | `""` | Yopass licence key for `auth.mode=oidc`. |
| secret.name | string | `""` | Name of the Secret. Defaults to the chart fullname when empty. |
| secret.oauth2ProxyClientId | string | `""` | Google OAuth2 client ID for `auth.mode=oauth2-proxy`. |
| secret.oauth2ProxyClientSecret | string | `""` | Google OAuth2 client secret for `auth.mode=oauth2-proxy`. |
| secret.oauth2ProxyCookieSecret | string | `""` | Cookie-signing seed for oauth2-proxy. Must be 16, 24 or 32 bytes — `openssl rand -base64 32 | tr -- '+/' '-_'`. Changing it logs everyone out. |
| secret.oidcClientSecret | string | `""` | OAuth2 client secret for `auth.mode=oidc`. |
| secret.oidcSessionKey | string | `""` | 64-byte hex session key shared by all replicas in `auth.mode=oidc` (`--oidc-session-key`), from `openssl rand -hex 64`. Without it users are logged out whenever a request lands on another pod. |
| secret.redisUrl | string | `""` | Redis URL, when it carries a password and `database.type=redis`. |
| secretKeys | object | `{"apiToken":"api-token","licenseKey":"license-key","oauth2ProxyClientId":"oauth2-proxy-client-id","oauth2ProxyClientSecret":"oauth2-proxy-client-secret","oauth2ProxyCookieSecret":"oauth2-proxy-cookie-secret","oidcClientSecret":"oidc-client-secret","oidcSessionKey":"oidc-session-key"}` | Keys read out of the Secret. Override when an existing Secret names them differently. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container-level security context, applied to every container in the pod. Yopass keeps nothing on disk unless `oafpass.fileStore` is set to `local`. |
| service.port | int | `80` | Service port. Traffic lands on oauth2-proxy when `auth.mode=oauth2-proxy`, otherwise straight on Yopass. |
| service.type | string | `"ClusterIP"` | Service type. |
| serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount. |
| serviceAccount.automount | bool | `false` | Mount the ServiceAccount token into the pods. Yopass talks to no Kubernetes API, so this stays off. |
| serviceAccount.create | bool | `true` | Create a ServiceAccount for the Yopass pods. |
| serviceAccount.name | string | `""` | Name of the ServiceAccount to use. Generated from the fullname when empty. |
| tolerations | list | `[]` | Tolerations for the pods. |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for the pods. |
