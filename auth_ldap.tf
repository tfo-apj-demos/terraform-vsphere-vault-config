# --- Config for the LDAP auth for users
/*resource "vault_ldap_auth_backend" "ldap" {
  path           = "ldap"
  url            = var.ldap_url
  userdn         = var.ldap_userdn
  binddn         = var.ldap_binddn
  bindpass       = var.ldap_bindpass
  groupdn        = var.ldap_groupdn
  token_policies = ["default"]
}*/