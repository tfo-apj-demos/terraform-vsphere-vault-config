# --- Config for JWT auth used by TFC

resource "vault_jwt_auth_backend" "tfc" {
  path               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
}

resource "vault_jwt_auth_backend_role" "tfc" {
  backend   = vault_jwt_auth_backend.tfc.path
  role_name = "tfc"
  token_policies = [
    "create_child_token",
    "configure_db_connection",
    "read_db_creds",
    "create_workspace_policy",
    "create_ssh_role",
    "manage_service_principal_kvs",
    "ldap_reader"
  ]

  bound_audiences = [
    "vault.tfc.workspace.identity"
  ]
  bound_claims_type = "glob"
  bound_claims = {
    sub                       = "organization:tfo-apj-demos:*"
    terraform_organization_id = "org-6nfrqkZhPPHJWG5h"
  }
  user_claim = "terraform_workspace_id"
  role_type  = "jwt"

  claim_mappings = {
    terraform_project_id   = "terraform_project_id"
    terraform_workspace_id = "terraform_workspace_id"
  }
  token_ttl    = 8 * 60 * 60 # 8 hours by 60 minutes by 60 seconds
  token_period = 8 * 60 * 60
}

resource "vault_jwt_auth_backend" "openshift" {
  description        = "JWT Backend for GitLab"
  path               = "jwt-gitlab"
  oidc_discovery_url = "https://gitlab.com"
  bound_issuer       = "https://gitlab.com"
}

resource "vault_jwt_auth_backend_role" "openshift" {
  backend           = vault_jwt_auth_backend.openshift.path
  role_name         = "openshift"
  role_type         = "jwt"
  bound_claims_type = "glob"
  bound_audiences   = ["https://vault.hashicorp.local:8200"]

  user_claim = "project_id"
  #user_claim = "user_email"
  bound_claims = {
    project_id = "*"
  }
  claim_mappings = {
    "user_email"   = "user_email"
    "project_id"   = "project_id"
    "user_id"      = "user_id"
    "project_path" = "project_path"
    "user_login"   = "user_login"
  }

  token_policies = ["create_child_token", "update_approle"]
  token_max_ttl  = "900"
}

# --- Config for JWT/OIDC auth used by Ansible Automation Platform (AAP 2.7) ---
# The AAP gateway acts as an OIDC IdP: at job launch it mints a short-lived,
# gateway-signed "workload identity" JWT describing the *job* (organization,
# inventory, job template, project, launched_by, ...). Jobs using the
# "HashiCorp Vault Secret Lookup (OIDC)" credential present that JWT here
# instead of a static AppRole secret_id — replacing the approle flow the
# snow_drift_tickets role uses today.
# Issuer + JWKS confirmed live from the gateway:
#   issuer   : https://aap-aap.apps.openshift-01.hashicorp.local/o
#   jwks_uri : https://aap-aap.apps.openshift-01.hashicorp.local/o/.well-known/jwks.json
resource "vault_jwt_auth_backend" "aap" {
  description = "JWT/OIDC backend for AAP workload identity (AAP 2.7)"
  path        = "jwt-aap"
  # ISSUER NOTE — the gateway's discovery doc advertises issuer "https://.../o"
  # (no slash), but BOTH the credential Test button AND real job workload tokens
  # actually carry iss "https://.../o/" (WITH trailing slash). bound_issuer is
  # authoritative when set (it overrides the discovery-document issuer), so we
  # pin it to the value the tokens really use. oidc_discovery_url stays slash-less
  # so Vault resolves ".../o/.well-known/openid-configuration" correctly.
  oidc_discovery_url = "https://aap-aap.apps.openshift-01.hashicorp.local/o"
  bound_issuer       = "https://aap-aap.apps.openshift-01.hashicorp.local/o/"
}

resource "vault_jwt_auth_backend_role" "aap" {
  backend   = vault_jwt_auth_backend.aap.path
  role_name = "aap-automation"
  role_type = "jwt"

  # AAP stamps the credential's Vault URL into the JWT `aud` claim
  # (awx jobs.py: audience = source_credential.get_input('url')), so this must
  # equal the Server URL configured on the AAP OIDC credential.
  bound_audiences = ["https://vault.hashicorp.local:8200"]

  # Authorize only jobs in the "Default" org running against "Demo Inventory".
  # (Teams are not part of the workload-identity claim set — organization /
  # inventory / job_template are the available structural scopes.)
  bound_claims_type = "string"
  bound_claims = {
    aap_controller_organization_name = "Default"
    aap_controller_inventory_name    = "Better Together Project - better-together-vm-lifecycle-dev"
  }

  # `sub` is the gateway-composed workload subject; used for the Vault entity
  # alias name (identity/audit), not for authorization.
  user_claim = "sub"

  # Surface job context onto the issued Vault token for audit / policy templating.
  # IMPORTANT: claim_mappings values MUST be string claims — Vault aborts login
  # with "error converting claim '<x>' to string" for non-string claims. The AAP
  # gateway emits aap_controller_job_id (and *_id siblings) as INTEGERS, so they
  # cannot be mapped here. Map only the string *_name claims. (The numeric job_id
  # is still visible in the jwt-aap/login audit entry if needed for tracing.)
  claim_mappings = {
    aap_controller_organization_name = "aap_org"
    aap_controller_inventory_name    = "aap_inventory"
    aap_controller_job_template_name = "aap_job_template"
    aap_controller_launched_by_name  = "aap_launched_by"
  }

  token_policies = ["read_kv"]
  token_ttl      = 20 * 60 # 20m — the secret lookup runs at job start; keep short
  token_max_ttl  = 60 * 60
}

# --- SSH signing role for the AAP "HashiCorp Vault Signed SSH (OIDC)" credential ---
# Backs AAP credential type 40 (OIDC). Replaces the AppRole flow used by the
# legacy "HashiCorp Vault Signed SSH" config credential (role_id/secret_id).
# Instead of a static AppRole secret, AAP jobs present the gateway-signed
# workload-identity JWT (same jwt-aap backend as aap-automation) and exchange it
# for a short-lived token carrying only the sign_ssh policy (ssh/sign/*).
#
# Deliberately scoped wider than aap-automation: SSH signing is needed by jobs
# across MANY inventories (~30 job templates), so we bind on audience + org
# rather than a single inventory. The audience binding is the real lock — it
# equals the Server URL on the AAP credential, which the gateway stamps into the
# JWT `aud` claim.
resource "vault_jwt_auth_backend_role" "aap_ssh_signer" {
  backend   = vault_jwt_auth_backend.aap.path
  role_name = "aap-ssh-signer"
  role_type = "jwt"

  # Must equal the Server URL configured on the AAP OIDC SSH credential.
  bound_audiences = ["https://vault.hashicorp.local:8200"]

  # Authorize any job in the "Default" org (no inventory restriction — these SSH
  # machine credentials are consumed by job templates across many inventories).
  bound_claims_type = "string"
  bound_claims = {
    aap_controller_organization_name = "Default"
  }

  user_claim = "sub"

  # Surface job context onto the issued token for audit of who signed what.
  # NOTE: only string claims are mappable — aap_controller_job_id is an INTEGER
  # and would abort login ("error converting claim ... to string"), so it's omitted.
  claim_mappings = {
    aap_controller_organization_name = "aap_org"
    aap_controller_job_template_name = "aap_job_template"
    aap_controller_launched_by_name  = "aap_launched_by"
  }

  # Signing only — no KV access. The issued token just needs to live long enough
  # to make the ssh/sign call at job start; the signed certificate carries its
  # own 8h TTL from the ssh secret backend role.
  token_policies = ["sign_ssh"]
  token_ttl      = 10 * 60 # 10m
  token_max_ttl  = 30 * 60
}

# --- Broad KV-read role for the AAP "HashiCorp Vault Secret Lookup (OIDC)" credential ---
# Backs AAP credential type 39 (OIDC external lookup). Replaces the AppRole flow
# of the legacy "HashiCorp Vault Access" config credential (id 19, custom type
# 32) for the FIXED-secret case: at job launch AAP exchanges the gateway-signed
# workload-identity JWT (same jwt-aap backend) for a short-lived read_kv token,
# reads one secret, and injects it into a credential field. (The workload JWT is
# NOT exposed to the playbook runtime — confirmed in awx jobs.py
# populate_workload_identity_tokens — so dynamic in-playbook OIDC lookups are not
# possible; this role serves the server-side external-lookup pattern only.)
#
# Deliberately scoped wider than aap-automation, which binds a single inventory
# ("better-together-vm-lifecycle-dev") and is too narrow for the ~30 job
# templates that consume KV secrets across many inventories. Like aap-ssh-signer,
# we bind on audience + org only; the audience binding is the real lock (it
# equals the Server URL stamped into the JWT `aud` claim by the gateway).
resource "vault_jwt_auth_backend_role" "aap_kv_reader" {
  backend   = vault_jwt_auth_backend.aap.path
  role_name = "aap-kv-reader"
  role_type = "jwt"

  # Must equal the Server URL configured on the AAP OIDC secret-lookup credential.
  bound_audiences = ["https://vault.hashicorp.local:8200"]

  # Any job in the "Default" org (no inventory restriction — KV secrets are read
  # by job templates spanning many inventories).
  bound_claims_type = "string"
  bound_claims = {
    aap_controller_organization_name = "Default"
  }

  user_claim = "sub"

  # Surface job context onto the issued token for audit of who read what.
  # NOTE: only string claims are mappable — aap_controller_job_id is an INTEGER
  # and would abort login ("error converting claim ... to string"), so it's
  # omitted. (Same gotcha that bit aap-automation / aap-ssh-signer.)
  claim_mappings = {
    aap_controller_organization_name = "aap_org"
    aap_controller_job_template_name = "aap_job_template"
    aap_controller_launched_by_name  = "aap_launched_by"
  }

  # read_kv grants secret/data/* (same policy aap-automation uses). The lookup
  # runs once at job start, so keep the token short-lived.
  token_policies = ["read_kv"]
  token_ttl      = 20 * 60 # 20m
  token_max_ttl  = 60 * 60
}