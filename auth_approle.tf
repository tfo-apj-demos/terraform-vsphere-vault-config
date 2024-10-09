resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "ansible" {
  backend         = vault_auth_backend.approle.path
  role_name       = "ansible"
  token_policies  = ["sign_ssh"]
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.ansible.role_name
}