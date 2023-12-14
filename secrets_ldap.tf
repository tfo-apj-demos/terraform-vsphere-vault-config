# --- Config for the LDAP secrets engine
resource "vault_ldap_secret_backend" "this" {
  schema          = "ad"
  path            = var.ldap_path
  binddn          = var.ldap_binddn
  bindpass        = var.ldap_bindpass
  url             = var.ldap_url # have to provide the server here to match the certificate
  userdn          = var.ldap_userdn
  certificate     = file("${path.module}/ca_cert_dir/root_ca.pem")
  password_policy = vault_password_policy.active_directory.id
}