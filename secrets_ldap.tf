# --- Config for the LDAP secrets engine

resource "vault_password_policy" "active_directory" {
  # --- Working from https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/password-must-meet-complexity-requirements
  name = "active_directory"

  policy = <<EOT
    length = 20
    rule "charset" {
      charset = "abcdefghijklmnopqrstuvwxyz"
      min-chars = 1
    }
    rule "charset" {
      charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      min-chars = 1
    }
    rule "charset" {
      charset = "0123456789"
      min-chars = 1
    }
    rule "charset" {
      charset = "'-!"#$%&()*,./:;?@[]^_`{|}~+<=>"
      min-chars = 1
    }
  EOT
}

resource "vault_ldap_secret_backend" "this" {
  path            = var.ldap_path
  binddn          = var.ldap_binddn
  bindpass        = var.ldap_bindpass
  url             = var.ldap_url # have to provide the server here to match the certificate
  userdn          = var.ldap_userdn
  certificate     = file("${path.module}/ca_cert_dir/root_ca.pem")
  password_policy = vault_password_policy.active_directory.id
  schema          = "ad"
}

resource "vault_ldap_secret_backend_library_set" "this" {
  mount                        = vault_ldap_secret_backend.this.path
  name                         = "iis_dev_library"
  service_account_names        = ["sr_vault_iis_dev_01@hashicorp.local", "sr_vault_iis_dev_02@hashicorp.local"]
  ttl                          = 3600 # One hour
  disable_check_in_enforcement = true
  max_ttl                      = 8 * 3600 # Makes it easy to see this is eight hours
}

resource "vault_ldap_secret_backend_dynamic_role" "this" {
  for_each  = tomap({ for role in var.ldap_roles : role.role_name => role })
  mount     = vault_ldap_secret_backend.this.path
  role_name = each.value.role_name
  creation_ldif = templatefile("${path.module}/files/creation.ldif.tmpl", {
    group_names = each.value.group_names
  })
  deletion_ldif     = file("${path.module}/files/deletion.ldif")
  rollback_ldif     = file("${path.module}/files/rollback.ldif")
  default_ttl       = 3600     # One hour
  max_ttl           = 8 * 3600 # Make it easy to see this is eight hours
  username_template = "{{printf \"%s%s%s%s\" (.DisplayName | truncate 8) (.RoleName | truncate 8) (random 20)| truncate 20}}"
}