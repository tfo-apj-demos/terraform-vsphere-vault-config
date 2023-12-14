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