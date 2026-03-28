# Keycloak Setup for Apicurio Studio and Microcks

## Prerequisites

- Access to your Keycloak Admin Console
- An existing realm (e.g., `Apicurio` or your organization's realm)

## 1. Create the `apicurio` Client (Apicurio Studio)

1. Log in to the Keycloak Admin Console
2. Select your realm from the dropdown
3. Go to **Clients** > **Create Client**

### General Settings

| Field | Value |
|-------|-------|
| Client ID | `apicurio` (or your `keycloak.client.id` value) |
| Name | `Apicurio Studio` |
| Client Protocol | `openid-connect` |

Click **Next**.

### Capability Config

| Field | Value |
|-------|-------|
| Client authentication | **ON** (confidential client) |
| Standard flow | **ON** |
| Direct access grants | **ON** |
| Service accounts roles | **ON** |
| Implicit flow | OFF |

Click **Next**.

### Login Settings

Set **Valid Redirect URIs** for your deployment:

| Field | Value |
|-------|-------|
| Valid Redirect URIs | `https://<your-apicurio-hostname>/*` |
| Web Origins | `+` |

> Setting Web Origins to `+` means "allow all Valid Redirect URI origins for CORS".

Click **Save**.

### Retrieve the Client Secret

1. Go to **Clients** > **apicurio** > **Credentials** tab
2. Copy the **Client secret** value

This is your `keycloak.client.secret` Helm value.

### Important: Disable Full Scope

To prevent bloated tokens (see Known Issues in README):

1. Go to **Clients** > **apicurio** > **Client scopes** tab
2. Click on **apicurio-dedicated**
3. Go to **Scope** tab
4. Set **Full scope allowed** to **OFF**

## 2. Create the `microcks-app` Client (Microcks Backend)

> Only needed if you enable Microcks (`microcks.enabled=true`).

1. Go to **Clients** > **Create Client**

### General Settings

| Field | Value |
|-------|-------|
| Client ID | `microcks-app` |
| Client Protocol | `openid-connect` |

### Capability Config

| Field | Value |
|-------|-------|
| Client authentication | **ON** |
| Standard flow | OFF |
| Direct access grants | OFF |
| Service accounts roles | OFF |
| Implicit flow | OFF |

> This is a bearer-only client -- uncheck all flows.

Click **Save**.

### Create Client Roles

Go to **Clients** > **microcks-app** > **Roles** tab and create:

| Role name |
|-----------|
| `admin` |
| `manager` |
| `user` |

> Microcks uses `keycloak.use-resource-role-mappings=true`, so roles must be on the **client**, not the realm.

## 3. Create the `microcks-app-js` Client (Microcks UI)

The Microcks frontend uses `microcks-app-js` as its client ID (hardcoded in the UI).

### General Settings

| Field | Value |
|-------|-------|
| Client ID | `microcks-app-js` |
| Client Protocol | `openid-connect` |

### Capability Config

| Field | Value |
|-------|-------|
| Client authentication | OFF (public client) |
| Standard flow | **ON** |
| Direct access grants | **ON** |

### Login Settings

| Field | Value |
|-------|-------|
| Valid Redirect URIs | `https://<your-microcks-hostname>/*` |
| Valid Redirect URIs | `http://localhost:9393/*` |
| Valid post logout redirect URIs | `https://<your-microcks-hostname>/*` |
| Valid post logout redirect URIs | `http://localhost:9393/*` |
| Web Origins | `*` |

## 4. Create the `microcks-serviceaccount` Client (Apicurio-to-Microcks Integration)

This client allows Apicurio Studio to push API mocks to Microcks.

### General Settings

| Field | Value |
|-------|-------|
| Client ID | `microcks-serviceaccount` |
| Client Protocol | `openid-connect` |

### Capability Config

| Field | Value |
|-------|-------|
| Client authentication | **ON** |
| Standard flow | OFF |
| Direct access grants | OFF |
| Service accounts roles | **ON** |

### Assign Roles to the Service Account

1. Go to **Clients** > **microcks-serviceaccount** > **Service account roles** tab
2. Click **Assign role**
3. Filter by **microcks-app** client roles
4. Assign: `admin`, `manager`, `user`

### Get the Secret

1. Go to **Clients** > **microcks-serviceaccount** > **Credentials** tab
2. Copy the **Client secret**

This is your `microcks.client.secret` Helm value.

## 5. Assign Roles to Users

For users who need access to Microcks:

1. Go to **Users** > select a user
2. Go to **Role mapping** tab
3. Click **Assign role**
4. Filter by **microcks-app** client roles
5. Assign the appropriate role (e.g., `admin`)

## Helm Values Mapping

| Helm Value | Description |
|------------|-------------|
| `keycloak.url` | Your Keycloak base URL (e.g., `https://auth.example.com/auth`) |
| `keycloak.realm` | Your Keycloak realm name |
| `keycloak.client.id` | Apicurio client ID (default: `apicurio-studio`) |
| `keycloak.client.secret` | Apicurio client secret from step 1 |
| `microcks.client.id` | Microcks service account client ID (default: `microcks-serviceaccount`) |
| `microcks.client.secret` | Microcks service account client secret from step 4 |
| `microcks.keycloak.realm` | Microcks Keycloak realm (defaults to `keycloak.realm`) |
| `microcks.keycloak.resource` | Microcks backend client ID (default: `microcks-app`) |
