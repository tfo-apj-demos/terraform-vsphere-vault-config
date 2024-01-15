resource "vault_mount" "root" {
  path                      = var.pki_root_path
  type                      = "pki"
  description               = "This is an example Root PKI secret engine mount"
  default_lease_ttl_seconds = var.default_lease_ttl
  max_lease_ttl_seconds     = var.max_lease_ttl
}

resource "vault_pki_secret_backend_root_cert" "this" {
  depends_on         = [vault_mount.root]
  backend            = vault_mount.root.path
  type               = "internal"
  common_name        = var.root_ca_common_name
  format             = "pem"
  private_key_format = "der"
  key_type           = "rsa"
  key_bits           = var.pki_key_bits
  ttl                = var.pki_ttl
  ou                 = var.ou
  organization       = var.organization
  country            = var.country
  locality           = var.locality
  province           = var.province
}

resource "vault_mount" "intermediate" {
  path                      = var.pki_intermediate_path
  type                      = "pki"
  description               = "This is an example intermediate PKI secret engine mount"
  default_lease_ttl_seconds = var.default_lease_ttl
  max_lease_ttl_seconds     = var.max_lease_ttl
}

resource "vault_pki_secret_backend_intermediate_cert_request" "this" {
  backend     = vault_mount.intermediate.path
  type        = vault_pki_secret_backend_root_cert.this.type
  common_name = var.intermediate_ca_common_name
}

resource "vault_pki_secret_backend_root_sign_intermediate" "this" {
  backend      = vault_mount.root.path
  csr          = vault_pki_secret_backend_intermediate_cert_request.this.csr
  common_name  = var.intermediate_ca_common_name
  ou           = var.ou
  organization = var.organization
  country      = var.country
  locality     = var.locality
  province     = var.province
  revoke       = true
}

resource "vault_pki_secret_backend_intermediate_set_signed" "example" {
  backend     = vault_mount.intermediate.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.this.certificate
}

resource "vault_pki_secret_backend_config_urls" "this" {
  backend = vault_mount.intermediate.path
  issuing_certificates = ["http://127.0.0.1:8200/v1/pki/ca"]
  crl_distribution_points = ["http://127.0.0.1:8200/v1/pki/crl"]
}

resource "vault_pki_secret_backend_role" "this" {
  backend          = vault_mount.intermediate.path
  name             = var.role_name
  allowed_domains  = var.allowed_domains
  allow_subdomains = true
  max_ttl          = var.max_ttl
  organization     = [var.organization]
  ou               = [var.ou]
}