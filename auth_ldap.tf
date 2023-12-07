resource "vault_ldap_secret_backend" "config" {
  path          = var.ldap_path
  binddn        = var.ldap_binddn
  bindpass      = var.ldap_bindpass
  url           = var.ldap_url
  insecure_tls  = var.ldap_insecure_tls
  userdn        = var.ldap_userdn
}
