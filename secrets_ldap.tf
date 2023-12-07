# --- Config for the LDAP secrets engine
resource "vault_ldap_secret_backend" "config" {
  path         = var.ldap_path
  binddn       = var.ldap_binddn
  bindpass     = var.ldap_bindpass
  url          = var.ldap_url
  insecure_tls = var.ldap_insecure_tls
  userdn       = var.ldap_userdn
}

/*resource "vault_ldap_secret_backend_static_role" "role" {
  mount           = vault_ldap_secret_backend.config.path
  username        = "alice"
  dn              = "cn=alice,ou=users,dc=hashibank,dc=com"
  role_name       = "alice"
  rotation_period = 60
}*/

resource "vault_ldap_secret_backend_dynamic_role" "role" {
  mount         = vault_ldap_secret_backend.config.path
  role_name     = var.ldap_role_name
  creation_ldif = var.ldap_creation_ldif
  deletion_ldif = var.ldap_deletion_ldif
  rollback_ldif = var.ldap_rollback_ldif
  default_ttl   = 300
  max_ttl       = 3600
}
