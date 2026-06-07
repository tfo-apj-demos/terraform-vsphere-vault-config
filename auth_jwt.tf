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
  description        = "JWT/OIDC backend for AAP workload identity (AAP 2.7)"
  path               = "jwt-aap"
  oidc_discovery_url = "https://aap-aap.apps.openshift-01.hashicorp.local/o"
  bound_issuer       = "https://aap-aap.apps.openshift-01.hashicorp.local/o"
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
  claim_mappings = {
    aap_controller_organization_name = "aap_org"
    aap_controller_inventory_name    = "aap_inventory"
    aap_controller_job_template_name = "aap_job_template"
    aap_controller_launched_by_name  = "aap_launched_by"
    aap_controller_job_id            = "aap_job_id"
  }

  token_policies = ["read_kv"]
  token_ttl      = 20 * 60 # 20m — the secret lookup runs at job start; keep short
  token_max_ttl  = 60 * 60
}