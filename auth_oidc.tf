# --- Config for OIDC auth for users

# --- Config for OIDC auth for users

resource "vault_jwt_auth_backend" "this" {
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "https://production.vault.11eb56d6-0f95-3a99-a33c-0242ac110007.aws.hashicorp.cloud:8200/v1/admin/tfo-apj-demos/identity/oidc/provider/team_se"
  oidc_client_id     = "Ty0hFqlMC8FYWpkz8znBeZxu0qz05lno"
  oidc_client_secret = var.oidc_client_secret
  default_role       = "systems_engineer"

}

resource "vault_jwt_auth_backend_role" "this" {
  backend               = vault_jwt_auth_backend.this.path
  role_name             = "systems_engineer"
  token_policies        = [

  ]
  bound_claims = {
    username = "username"
  }
  claim_mappings = {
    "/token/username" = "username",
    "/token/groups" = "groups"
  }
  
  user_claim            = "username"
  role_type             = "oidc"
  allowed_redirect_uris = [
    "http://localhost:8250/oidc/callback",
    "https://vault.hashicorp.local:8200/ui/vault/auth/oidc/oidc/callback",
  ]
  verbose_oidc_logging = true
  #groups_claim = "groups"
}