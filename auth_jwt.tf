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
    "manage_service_principal_kvs"
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
  token_ttl = 8*60*60 # 8 hours by 60 minutes by 60 seconds
  token_period = 8*60*60
}

resource "vault_jwt_auth_backend" "openshift" {
  description        = "JWT Backend for GitLab"
  path               = "jwt"
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

  token_policies = ["create_child_token"]
  token_max_ttl  = "900"
}