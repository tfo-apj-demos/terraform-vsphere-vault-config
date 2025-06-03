resource "vault_auth_backend" "this" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend            = vault_auth_backend.this.path

  kubernetes_host    = var.kubernetes_api
  kubernetes_ca_cert = base64decode(var.kubernetes_ca_cert) 
  token_reviewer_jwt = var.token_reviewer_jwt
  issuer             = "https://kubernetes.default.svc"
}

resource "vault_kubernetes_auth_backend_role" "tfe" {
  backend                          = vault_auth_backend.this.path
  role_name                        = "tfe"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["tfe"]
  token_ttl                        = 259200
  token_policies                   = ["default", "create_pki"]
  audience = "vault"
}

resource "vault_kubernetes_auth_backend_role" "aap" {
  backend                          = vault_auth_backend.this.path
  role_name                        = "aap"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["aap"]
  token_ttl                        = 259200
  token_policies                   = ["default", "sign_ssh", "create_pki"]
  audience = "https://kubernetes.default.svc"
}

resource "vault_kubernetes_auth_backend_role" "awx" {
  backend                          = vault_auth_backend.this.path
  role_name                        = "awx"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["awx"]
  token_ttl                        = 259200
  token_policies                   = ["default", "sign_ssh", "create_pki"]
  audience = "https://kubernetes.default.svc"
}

resource "vault_kubernetes_auth_backend_role" "gitlab" {
  backend                          = vault_auth_backend.this.path
  role_name                        = "gitlab"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["gitlab"]
  token_ttl                        = 259200
  token_policies                   = ["default",  "create_pki"]
  audience = "https://kubernetes.default.svc"
}

resource "vault_kubernetes_auth_backend_role" "vault_live_secrets_demo" {
  backend                          = vault_auth_backend.this.path
  role_name                        = "vault-live-secrets-demo"
  bound_service_account_names      = ["*"]
  bound_service_account_namespaces = ["vault-live-secrets-demo"]
  token_ttl                        = 259200
  token_policies                   = ["default", "read_kv"]
  audience = "https://kubernetes.default.svc"
}