# --- Config for JWT auth used by TFC

resource "vault_jwt_auth_backend" "tfc" {
    path                = "jwt"
    oidc_discovery_url  = "https://app.terraform.io"
    bound_issuer        = "https://app.terraform.io"
}

resource "vault_jwt_auth_backend_role" "tfc" {
  backend         = vault_jwt_auth_backend.tfc.path
  role_name       = "tfc"
  token_policies  = [
    "create_child_token"
  ]

  bound_audiences = [
    "vault.tfc.workspace.identity"
  ]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:tfo-apj-demos:*"
    terraform_organization_id = "org-6nfrqkZhPPHJWG5h"
  }
  user_claim      = "terraform_full_workspace"
  role_type       = "jwt"

  claim_mappings = {
    terraform_project_id = "terraform_project_id"
    terraform_workspace_id = "terraform_workspace_id"
  }
}