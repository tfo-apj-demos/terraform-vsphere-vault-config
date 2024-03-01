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
    "create_workspace_policy"
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