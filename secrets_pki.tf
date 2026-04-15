resource "vault_mount" "pki" {
  type = "pki"
  path = "pki"
}

resource "vault_pki_secret_backend_config_ca" "this" {
  backend    = vault_mount.pki.path
  pem_bundle = <<EOH
-----BEGIN CERTIFICATE-----
MIICJzCCAaygAwIBAgIQbn3a3bybm4RDhMIGFhZPcTAKBggqhkjOPQQDBDBBMRUw
EwYKCZImiZPyLGQBGRYFbG9jYWwxGTAXBgoJkiaJk/IsZAEZFgloYXNoaWNvcnAx
DTALBgNVBAMTBHJvb3QwHhcNMjMxMTIxMDYyNjI4WhcNMjgxMTIxMDYzNjI3WjBB
MRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxGTAXBgoJkiaJk/IsZAEZFgloYXNoaWNv
cnAxDTALBgNVBAMTBHJvb3QwdjAQBgcqhkjOPQIBBgUrgQQAIgNiAASHn0R2nubu
WihsZAto+2NiGp5aPO9RU8lCdrFpn4q5v7/15c03rMvLSGaPWueqLaeeuw1DGwua
2z8qmNDTAs1i16o4MX53X7fSdR6ZqAQhQg8keN54FJoQ7XH8ZcqusOijaTBnMBMG
CSsGAQQBgjcUAgQGHgQAQwBBMA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTAD
AQH/MB0GA1UdDgQWBBSgNqfA0i1xcfIRmDPes6iZGbIXjjAQBgkrBgEEAYI3FQEE
AwIBADAKBggqhkjOPQQDBANpADBmAjEAlWq0q+yCIh8blUbwuTgviS28REb0lSRy
zrM7+vEt/KAarK9mPPg7Eop4MEiGhMz9AjEAx5suBunl6NSLDMpASeSkzdD+QElV
SRhpTJqh1IW9s+jARBtT1+SJiO3ZXTs7INMm
-----END CERTIFICATE-----
EOH
}

/*resource "vault_pki_secret_backend_intermediate_cert_request" "this" {
 backend      = vault_mount.pki.path
 type         = "internal"
 common_name  = "GCVE Vault Intermediate"
 key_type     = "ec"
 key_bits     = "384"
 organization = "WWTFO"
 ou           = "TFO_APJ_DEMOS"
 country      = "AU"
 locality     = "Sydney"
}*/

resource "vault_pki_secret_backend_intermediate_set_signed" "this" {
  backend     = vault_mount.pki.path
  certificate = <<EOH
-----BEGIN CERTIFICATE-----
MIIC8DCCAnWgAwIBAgIUWpzfYp4BW5rQQ6hFoI//0O7k2zMwCgYIKoZIzj0EAwMw
gYkxCzAJBgNVBAYTAkFVMRgwFgYDVQQIEw9OZXcgU291dGggV2FsZXMxDzANBgNV
BAcTBlN5ZG5leTEMMAoGA1UEChMDU0VBMRQwEgYDVQQLEwtDZW50cmFsIFBLSTEr
MCkGA1UEAxMiaGFzaGljb3JwLmxvY2FsIENlbnRyYWwgU2lnbmluZyBDQTAeFw0y
NjAzMTQwMjA3MTNaFw0yODAzMTMwMjA3NDNaMCIxIDAeBgNVBAMTF0dDVkUgVmF1
bHQgSW50ZXJtZWRpYXRlMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEZkcKMdpHB9sx
nDoOjacYrGSnRZjphbqIOy1iy2K6TBUQFAnFb9HTXTfyZNKJ3BmH5NzLCsqPxr+j
Gm2tJU+Oj1g9eYTT/4YkHFB3/4EURkTLjZH7W8dEOtxRIR7npty3o4IBAjCB/zAO
BgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUcwgkkQ4l
OsINy6kjo6dNY2T8boUwHwYDVR0jBBgwFoAUZhccm4m/9iMCFUDNveuD8k4oXw4w
UgYIKwYBBQUHAQEERjBEMEIGCCsGAQUFBzAChjZodHRwczovL3ZhdWx0Lmhhc2hp
Y29ycC5sb2NhbC92MS9jZW50cmFsLXNpZ25pbmctY2EvY2EwSAYDVR0fBEEwPzA9
oDugOYY3aHR0cHM6Ly92YXVsdC5oYXNoaWNvcnAubG9jYWwvdjEvY2VudHJhbC1z
aWduaW5nLWNhL2NybDAKBggqhkjOPQQDAwNpADBmAjEAjjab1oGPMmKqyIw77XIC
2Tmk5J+ExjWLMf4WEfVewDuNKZIPZUxlsHu2YvTplq4RAjEA89+g/BJaMCHslX9/
b0MaKERdTwgTHiyR3E+wiirVtOIKyKrhtAZEE9ScP51TfAYi
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIEqDCCApCgAwIBAgIUQeAXM66DYA1j7VgO99xEElZCpvQwDQYJKoZIhvcNAQEL
BQAwPjEXMBUGA1UEChMOSENQIFZhdWx0IEdDVkUxIzAhBgNVBAMTGkhDUCBWYXVs
dCBSb290IENBIGZvciBHQ1ZFMB4XDTI1MTEyNTEwMzU1M1oXDTMwMTEyNDEwMzYy
M1owgYkxCzAJBgNVBAYTAkFVMRgwFgYDVQQIEw9OZXcgU291dGggV2FsZXMxDzAN
BgNVBAcTBlN5ZG5leTEMMAoGA1UEChMDU0VBMRQwEgYDVQQLEwtDZW50cmFsIFBL
STErMCkGA1UEAxMiaGFzaGljb3JwLmxvY2FsIENlbnRyYWwgU2lnbmluZyBDQTB2
MBAGByqGSM49AgEGBSuBBAAiA2IABA6owZ+KPe8rvSLW6BTDM4OKFj17dLe5DG+8
EiorhwmQveiKQJzeVQAG3GP0VlFJSxH+qI4iYuqFEQ9TQZcnd12UhohjqQtFkau5
c11ZtS+l/nt9/teMIKb342O/BViN4qOB/zCB/DAOBgNVHQ8BAf8EBAMCAQYwDwYD
VR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUZhccm4m/9iMCFUDNveuD8k4oXw4wHwYD
VR0jBBgwFoAUnX1HtEAuTdn19JuC9Z7czml94EswSwYIKwYBBQUHAQEEPzA9MDsG
CCsGAQUFBzAChi9odHRwczovL3ZhdWx0Lmhhc2hpY29ycC5sb2NhbC5jb20vdjEv
cm9vdC1jYS9jYTA7BgNVHR8ENDAyMDCgLqAshipodHRwczovL3ZhdWx0Lmhhc2hp
Y29ycC5jb20vdjEvcm9vdC1jYS9jcmwwDwYDVR0RBAgwBocEfwAAATANBgkqhkiG
9w0BAQsFAAOCAgEAOSPPTai7Gms3UN/FpugJYZdqjQM1vNc317VjysUYGz97Xkjh
f+ynmgxIMtsw8X7zFiTE2C3kYU/ojTZHtnecxQmyovCkhMChzOx19DBEiMQw9vxS
kYa/yoEojhRqEOmRId9Xg8lA9Bbo995gaMppp9lY/CtDvQxACf3ptu+xdMBmEXsS
1qyWlSjIupB7lvZYdpga9MvxnG+7AslAHaM9Kq6VfTZYZMTmuY9+oLHHKJKKs5t5
hjfJGHI5SkVDlWMbWJWqUh4aZMbSkw/fgDXt7jieWLs348bx9CqQy/pOHY1TNwQ9
C/i7PrDbbhsujkvDzjuGCfpUHduO5wa3tY07aP7DajtnxUHcE5zSiFovli+qI1p+
PVKngGb1HyH9XQlfvA8LmEBVDg/r9zGUEKnez7ik4uUsbtl1ziS81gt8PbSnIh8F
Ri913a7swFIZdcYvPCtw+Hx7GgxzINbT6yOfxlUj3W3JwZ2nS4WX4gfMk6gg3OA6
sA09pokKw3TpJ4tz5a983/y5gOLblOoU2yeDR/7jWnoLkqRysRdKV32+hOvceyco
Gd0KKisTGfdCmhxXd6/kYLezKfURywEbZsWqQhFeJSJisJngeGWYIiChVlwoaXRB
3CmJdbChrw65KELQFI+kEIjOYsQAmCboFFkL//vv+gPCFn3emvatbxcbgG0=
-----END CERTIFICATE-----
EOH
}

resource "vault_pki_secret_backend_config_issuers" "this" {
  count                  = length(vault_pki_secret_backend_intermediate_set_signed.this.imported_issuers) > 0 ? 1 : 0
  backend                = vault_mount.pki.path
  default                = vault_pki_secret_backend_intermediate_set_signed.this.imported_issuers[0]
  default_follows_latest_issuer = true
}

# PKI Role for TLS Authentication Certificates
# Used by: AAP workflow to sign CSRs for Vault Agent authentication
# Purpose: Client authentication TO Vault using TLS cert auth method
resource "vault_pki_secret_backend_role" "tls_auth" {
  name    = "tls-auth"
  backend = vault_mount.pki.path
  
  # Longer TTL for authentication certificates (30 days default, max 3 months)
  ttl     = "2592000"   # 30 days
  max_ttl = "7776000"  # 90 days
  
  # Domain restrictions
  allowed_domains = [
    "hashicorp.local"
  ]
  allow_subdomains  = true
  enforce_hostnames = true
  allow_bare_domains = false
  allow_glob_domains = false
  
  # Key configuration
  key_type = "rsa"
  key_bits = 2048
  
  # Certificate usage - CLIENT AUTHENTICATION ONLY
  server_flag = false  # NOT for server auth
  client_flag = true   # For client auth
  
  # Extended Key Usage - ClientAuth only
  ext_key_usage = [
    "ClientAuth"
  ]
  
  # Key Usage - appropriate for client auth
  key_usage = [
    "DigitalSignature",
    "KeyAgreement"
  ]
  
  # Additional security
  allow_ip_sans = false  # Auth certs don't need IP SANs
  allow_any_name = false
  
  # No URI SANs needed for auth certs
  allowed_uri_sans = []
}

# PKI Role for Application Server Certificates  
# Used by: Vault Agent templates to auto-renew application certificates
# Purpose: Server certificates for applications (HTTPS, databases, etc.)
resource "vault_pki_secret_backend_role" "server" {
  name    = "server"
  backend = vault_mount.pki.path
  
  # Shorter TTL for application certificates (24h default, max 7 days)
  # Short TTL is fine since Vault Agent auto-renews
  ttl     = "86400"   # 24 hours
  max_ttl = "604800"  # 7 days
  
  # Domain restrictions
  allowed_domains = [
    "hashicorp.local"
  ]
  allow_subdomains  = true
  enforce_hostnames = true
  allow_bare_domains = false
  allow_glob_domains = false
  
  # Key configuration
  key_type = "rsa"
  key_bits = 2048
  
  # Certificate usage - SERVER AUTHENTICATION ONLY
  server_flag = true   # For server auth
  client_flag = false  # NOT for client auth
  
  # Extended Key Usage - ServerAuth only
  ext_key_usage = [
    "ServerAuth"
  ]
  
  # Key Usage - appropriate for server auth
  key_usage = [
    "DigitalSignature",
    "KeyEncipherment"
  ]
  
  # Additional features for application certificates
  allow_ip_sans = true  # Allow IP addresses in SANs
  allow_any_name = false
  
  # URI SANs for modern service mesh / SPIFFE compatibility
  allowed_uri_sans = [
    "*.hashicorp.local",
    "spiffe://hashicorp.local/*"
  ]
  
  # Allow localhost for development/testing
  allow_localhost = true
}

# Keep your existing role for backward compatibility or other uses
# You can deprecate this later once you've migrated
resource "vault_pki_secret_backend_role" "gcve" {
  name    = "gcve"
  backend = vault_mount.pki.path
  
  # Original settings
  max_ttl = "7890048" # approximately 3 months
  ttl     = "259200"  # 3 days
  
  allowed_domains = [
    "hashicorp.local"
  ]
  allowed_uri_sans = [
    "*.hashicorp.local",
  ]
  allow_ip_sans     = true
  allow_subdomains  = true
  enforce_hostnames = false
  
  # Since this has both flags, it's a dual-purpose cert
  # Consider deprecating in favor of specific roles above
  server_flag = true
  client_flag = true
}
