/*resource "vault_mount" "root" {
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
}*/

resource "vault_mount" "intermediate" {
  path                      = var.pki_intermediate_path
  type                      = "pki"
  description               = "This is an example intermediate PKI secret engine mount"
  default_lease_ttl_seconds = var.default_lease_ttl
  max_lease_ttl_seconds     = var.max_lease_ttl
}

resource "vault_pki_secret_backend_intermediate_cert_request" "this" {
  backend     = vault_mount.intermediate.path
  type        = "internal"
  common_name = var.intermediate_ca_common_name
}

# Set the signed certificate from the external Root CA
resource "vault_pki_secret_backend_intermediate_set_signed" "example" {
  backend     = vault_mount.intermediate.path
  certificate = <<-EOT
    -----BEGIN CERTIFICATE-----
MIIDCjCCAo+gAwIBAgIUXC2WYhesZrf/5Rv4fVozFqeeE60wCgYIKoZIzj0EAwMw
ZzELMAkGA1UEBhMCQVUxDzANBgNVBAcTBlN5ZG5leTEOMAwGA1UEChMFV1dURk8x
FjAUBgNVBAsMDVRGT19BUEpfREVNT1MxHzAdBgNVBAMTFkhDUCBWYXVsdCBJbnRl
cm1lZGlhdGUwHhcNMjQwMTE1MDE1OTE1WhcNMjUwMTE1MDAwMDAwWjAgMR4wHAYD
VQQDExV2YXVsdC5oYXNoaWNvcnAubG9jYWwwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQCuydw+ELLGsjMTgnOpM3Ru7iVkxt81WcnRgBXpJBu39+5spnAS
4qQQHoalU0BWhdL41JbJHHktaM50CH5NaU/XmsPN18yjTnUWz/ap1v7+Rd9NcgvO
Kjmwo+8n4uUvSADo00dGwFJ63GymAYT3EK2TxLyDM8dj98Rcdxt512k8ZKSt7tvb
l/YM9rHR48zutJnrG8Tf2EiMRY4BJVQjm97hY0Umv6xNVWewpjs4ijFrjAEdTCKc
Bjgi9l4kTHOi9M7IOJXliVqeKP0FTfhGY42ehW0rdgCAqQSad30bO9gBl1FuQpfO
e+rkn0Yjx5j5qVJeuWdlWxRDjNzvlvIRJVYzAgMBAAGjgZQwgZEwDgYDVR0PAQH/
BAQDAgOoMB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAdBgNVHQ4EFgQU
Jd2vJiVj2fTambNkKFjzODAdLbIwHwYDVR0jBBgwFoAUSVrBWV2ItcjjOthosWWh
hDZMtOcwIAYDVR0RBBkwF4IVdmF1bHQuaGFzaGljb3JwLmxvY2FsMAoGCCqGSM49
BAMDA2kAMGYCMQC4WznH2Xy70/F0IF42SyjH3QZT6/Nta3WLt1OgLnTDLkRcZ0FN
MAdq9mOk9vMDYekCMQD41cpVbxjQMz/aNv6QgSrRKfDDzBkFvde1zXrfGU1vkDtG
BlW6IO9oBV1eXnAVO/Y=
-----END CERTIFICATE-----
  EOT
}

resource "vault_pki_secret_backend_config_urls" "this" {
  backend = vault_mount.intermediate.path
  issuing_certificates    = ["${var.external_root_ca_url}/ca"]
  crl_distribution_points = ["${var.external_root_ca_url}/crl"]
}

resource "vault_pki_secret_backend_role" "this" {
  backend          = vault_mount.intermediate.path
  name             = var.role_name
  allowed_domains  = var.allowed_domains
  allow_subdomains = true
  max_ttl          = var.max_ttl
}