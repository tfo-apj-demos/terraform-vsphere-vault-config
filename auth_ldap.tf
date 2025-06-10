# --- Config for the LDAP auth for users
resource "vault_ldap_auth_backend" "ldap" {
  path           = var.ldap_path
  binddn         = var.ldap_binddn
  bindpass       = var.ldap_bindpass
  url            = var.ldap_url
  userdn         = var.ldap_userdn
  groupdn        = var.ldap_groupdn
  certificate    = file("${path.module}/ca_cert_dir/root_ca.pem")
  token_policies = ["default"]
}