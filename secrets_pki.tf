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
MIID7TCCA3KgAwIBAgITPAAAAAqqFlYu2+JURQAAAAAACjAKBggqhkjOPQQDBDBB
MRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxGTAXBgoJkiaJk/IsZAEZFgloYXNoaWNv
cnAxDTALBgNVBAMTBHJvb3QwHhcNMjQwMTE1MDQyNTAyWhcNMjYwMTE1MDQzNTAy
WjBoMQswCQYDVQQGEwJBVTEPMA0GA1UEBxMGU3lkbmV5MQ4wDAYDVQQKEwVXV1RG
TzEWMBQGA1UECwwNVEZPX0FQSl9ERU1PUzEgMB4GA1UEAxMXR0NWRSBWYXVsdCBJ
bnRlcm1lZGlhdGUwdjAQBgcqhkjOPQIBBgUrgQQAIgNiAAShicRdBqGgtgBIXn5F
JKyaNRPFpt/p/lCQcbH2SviZiX1l22NM+W2x6S/gFr/DqMLVlsz+v27lKXHUa0kd
r2a3a4GwqTSb3eCr2OgBVCfhK45hItAoc0JSCyPGCU+eULujggIDMIIB/zAdBgNV
HQ4EFgQUHry87aSrt6gU2n9ZYacSnQeWdrswHwYDVR0jBBgwFoAUoDanwNItcXHy
EZgz3rOomRmyF44wgcMGA1UdHwSBuzCBuDCBtaCBsqCBr4aBrGxkYXA6Ly8vQ049
cm9vdCxDTj1kYy0wLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxD
Tj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWhhc2hpY29ycCxEQz1sb2Nh
bD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JM
RGlzdHJpYnV0aW9uUG9pbnQwgboGCCsGAQUFBwEBBIGtMIGqMIGnBggrBgEFBQcw
AoaBmmxkYXA6Ly8vQ049cm9vdCxDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2Vy
dmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1oYXNoaWNvcnAs
REM9bG9jYWw/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmlj
YXRpb25BdXRob3JpdHkwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwDwYDVR0T
AQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAYYwCgYIKoZIzj0EAwQDaQAwZgIxALls
EHl0gk3De9dieswYciZZ1jzkp7oXPq4xqdJi70sp2ORS0FczC41z7flpIMF0LAIx
ALDx3WsMAVKFsFz8J0qKmP8wP/048Db8TEu9AuUzQ0sfMflrNhy/JbuGnIAUzmJR
mg==
-----END CERTIFICATE-----
EOH
}
# PKI Role for TLS Authentication Certificates
# Used by: AAP workflow to sign CSRs for Vault Agent authentication
# Purpose: Client authentication TO Vault using TLS cert auth method
resource "vault_pki_secret_backend_role" "tls_auth" {
  name    = "tls-auth"
  backend = vault_mount.pki.path
  
  # Longer TTL for authentication certificates (30 days default, max 3 months)
  ttl     = "720h"   # 30 days
  max_ttl = "2160h"  # 90 days
  
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
  ttl     = "24h"   # 24 hours
  max_ttl = "168h"  # 7 days
  
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
