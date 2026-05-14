# terraform-vsphere-vault-config

Day-2 configuration of a HashiCorp Vault cluster running in the internal vSphere environment. **This repo configures Vault — it does not deploy Vault.** The cluster itself is deployed by a separate repo; here we declare auth methods, secrets engines, policies, identity entities and groups, and PKI roles.

## When to touch this repo

- Add or change an auth method (AppRole, JWT, Kubernetes, LDAP, OIDC, TLS cert).
- Add or change a secrets engine (KV, database, LDAP, SSH, PKI).
- Add or rotate PKI roles, allowed domains, TTLs.
- Add or change a Vault policy or attach it to an identity group / role.
- Add new identity entities / aliases for human or service accounts.

## File layout

Each concern is one `.tf` file at the root so a reviewer can find the relevant config from the filename alone. Policy HCL bodies live in `policies/` and are loaded by `policies.tf`.

| File | Concern |
|------|---------|
| `auth_approle.tf` | AppRole auth backend + roles for service automation (Ansible, CI runners, etc.) |
| `auth_jwt.tf` | JWT/OIDC auth backends for HCP Terraform workload identity and other JWT issuers |
| `auth_k8s.tf` | Kubernetes auth backend(s) + roles bound to specific ServiceAccounts in cluster namespaces |
| `auth_ldap.tf` | LDAP auth backend for human operators (mapped to identity groups via group aliases) |
| `auth_oidc.tf` | OIDC auth backend for browser-driven SSO into the Vault UI |
| `auth_tls.tf` | TLS cert auth backend + role(s) for client-cert auth from Vault Agents on RHEL hosts |
| `auth_identity_entities.tf` | Identity entities, aliases, and groups that stitch auth methods together for a single human/principal |
| `secrets_db.tf` | Database secrets engine + dynamic role(s) for short-lived DB credentials |
| `secrets_kv.tf` | KV v2 mount(s) + seeded entries for shared API creds, subscription IDs, etc. |
| `secrets_ldap.tf` | LDAP secrets engine: dynamic roles, static roles, and library sets for AD-backed credentials |
| `secrets_pki.tf` | PKI mount, intermediate import, and roles (`tls_auth`, `server`, `gcve`). See "PKI" below. |
| `secrets_ssh.tf` | SSH secrets engine for signed-cert SSH access (one-time CAs) |
| `policies.tf` | Loads each `policies/*.hcl` file into a `vault_policy` resource |
| `policies/*.hcl` | Policy bodies (admin, ops-team, per-system policies, etc.) |
| `files/*.ldif*` | LDIF templates used by the LDAP secrets engine for create/delete/rollback |
| `outputs.tf` | Outputs consumed by other workspaces (mount paths, role names, etc.) |
| `variables.tf` | Input variables (e.g. domain names, role TTLs) |
| `providers.tf` | Vault, GitHub, and time providers; HCP Terraform cloud block |

## PKI structure

`secrets_pki.tf` configures Vault as an issuing CA. The chain:

```
External offline root CA (HCP-managed root)
      │ signs
External signing CA (central CA — public-key PEM imported as Vault's trust anchor)
      │ signs
Vault PKI intermediate (lives in this mount, issues end-entity certs)
      │ signs
Workload certs (server: 24h-7d, client/tls-auth: 30d-90d)
```

The Vault PKI intermediate is **set-signed**: Vault generates a CSR locally, it gets signed by the external signing CA out-of-band, and the signed cert + chain is pasted back into `vault_pki_secret_backend_intermediate_set_signed`. Vault never holds the external root's private key.

Three roles are defined:

- **`tls_auth`** — client-authentication certs (`client_flag = true`, `server_flag = false`). Used by Vault Agents on RHEL hosts to authenticate *to* Vault via TLS cert auth. Longer TTL (30 days) because re-issue is comparatively heavy.
- **`server`** — server-authentication certs (`server_flag = true`, `client_flag = false`). Used by Vault Agent templates to mint short-lived HTTPS certs for applications; auto-renew handles rotation.
- **`gcve`** — legacy dual-purpose role kept for backward compatibility. New consumers should use `tls_auth` or `server` instead.

## Auth method conventions

- **Human operators** authenticate via LDAP or OIDC. Each human is represented by a single `vault_identity_entity`, with `vault_identity_entity_alias` linking it to the LDAP or OIDC backend. Group memberships flow from the upstream directory via `vault_identity_group_alias`.
- **Workloads in Kubernetes / OpenShift** authenticate via the Kubernetes auth backend, with a role per ServiceAccount.
- **HCP Terraform workspaces** authenticate via JWT (workload identity) — see `auth_jwt.tf` for the `tfc` backend and role bindings.
- **Service automation outside K8s** (e.g. Ansible AAP) uses AppRole or TLS-cert auth depending on whether secret-id distribution or cert distribution is easier in that environment.

## Policy conventions

Policy files in `policies/` are named after the role/principal they grant (e.g. `admin.hcl`, `read_kv.hcl`, `tfc_sea.hcl`). `policies.tf` loads each one as a `vault_policy` resource named after the file. To add a new policy:

1. Drop the HCL body in `policies/<name>.hcl`.
2. `policies.tf` picks it up automatically (the file uses a glob loader).
3. Attach the policy to an auth role (or identity group) in the relevant `auth_*.tf` file.

## Providers

| Provider | Purpose |
|----------|---------|
| `hashicorp/vault` | All Vault config. Uses the `VAULT_ADDR` + `VAULT_TOKEN` (or workload identity JWT) on the executing agent. |
| `integrations/github` | Reads/writes GitHub identities consumed by the JWT/OIDC backends. |
| `hashicorp/time` | Used for rotation timing on a small number of resources. |

The cloud block in `providers.tf` pins this code to a single HCP Terraform workspace; remote state is centralized there.

## Operational notes

- **Vault must be unsealed and reachable** from the executing agent before `terraform plan` will succeed. Connection issues surface as `connection refused` or `permission denied` very early in refresh.
- **Order matters on first apply**: the PKI intermediate set-signed step requires the external signing CA to have already signed the CSR. The current `secrets_pki.tf` embeds an already-signed chain to avoid the chicken-and-egg; rotating the intermediate requires re-signing externally.
- **Policy changes are immediate** in Vault — there's no graceful drain. A policy that's broken on apply may lock out the operators who would otherwise fix it. Test policies in a non-prod Vault first.
- **Identity group memberships** flow from upstream directory groups via aliases. If a human seems to be missing permissions after a config change, check that their upstream group still matches the alias name set in the relevant `auth_*.tf`.
