# --- Config for the LDAP secrets engine
resource "vault_ldap_secret_backend" "config" {
  path         = var.ldap_path
  binddn       = var.ldap_binddn
  bindpass     = var.ldap_bindpass
  url          = "ldaps://dc-0.hashicorp.local" # have to provide the server here to match the certificate
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
  creation_ldif = file("${path.module}/files/creation.ldif")
  deletion_ldif = file("${path.module}/files/deletion.ldif")
  rollback_ldif = file("${path.module}/files/rollback.ldif")
  default_ttl   = 3600   # One hour
  max_ttl       = 8*3600 # Make it easy to see this is eight hours
  username_template = "{{printf \"%s%s%s%s\" (.DisplayName | truncate 8) (.RoleName | truncate 8) (random 20)| truncate 20}}"
}
