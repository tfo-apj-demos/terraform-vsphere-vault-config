# --- Config for the LDAP secrets engine
resource "vault_ldap_secret_backend" "this" {
  path         = var.ldap_path
  binddn       = var.ldap_binddn
  bindpass     = var.ldap_bindpass
  url          = "ldaps://dc-0.hashicorp.local" # have to provide the server here to match the certificate
  userdn       = var.ldap_userdn
  certificate  = file("${path.module}/ca_cert_dir/root_ca.pem")
}

resource "vault_ldap_secret_backend_dynamic_role" "default" {
  mount         = vault_ldap_secret_backend.this.path
  role_name     = var.ldap_role_name
  creation_ldif = templatefile("${path.module}/files/creation.ldif", {
    group_names =  ["vault_dynamic"]
  })
  deletion_ldif = file("${path.module}/files/deletion.ldif")
  rollback_ldif = file("${path.module}/files/rollback.ldif")
  default_ttl   = 3600   # One hour
  max_ttl       = 8*3600 # Make it easy to see this is eight hours
  username_template = "{{printf \"%s%s%s%s\" (.DisplayName | truncate 8) (.RoleName | truncate 8) (random 20)| truncate 20}}"
}

resource "vault_ldap_secret_backend_dynamic_role" "vsphere" {
  mount         = vault_ldap_secret_backend.this.path
  role_name     = "vsphere_virtual_machine_lifecycle"
  creation_ldif = templatefile("${path.module}/files/creation.ldif", {
    group_names =  ["vsphere_virtual_machine_lifecycle"]
  })
  deletion_ldif = file("${path.module}/files/deletion.ldif")
  rollback_ldif = file("${path.module}/files/rollback.ldif")
  default_ttl   = 3600   # One hour
  max_ttl       = 8*3600 # Make it easy to see this is eight hours
  username_template = "{{printf \"%s%s%s%s\" (.DisplayName | truncate 8) (.RoleName | truncate 8) (random 20)| truncate 20}}"
}
