resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "time_rotating" "daily" {
  #rotation_days = 1  # Rotate every 1 day (24 hours)
  rotation_minutes = 1
}

# Set up the approle role for Ansible Automation Platform
resource "vault_approle_auth_backend_role" "ansible" {
  backend         = vault_auth_backend.approle.path
  role_name       = "ansible"
  token_policies  = ["sign_ssh"]

  # Forces the role_id to be regenerated every 24 hours
  depends_on = [time_rotating.daily]
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.ansible.role_name

  # Forces the role_id to be regenerated every 24 hours
  depends_on = [time_rotating.daily]
}