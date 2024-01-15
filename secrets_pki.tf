resource "vault_mount" "pki" {
	type = "pki"
	path = "pki"
}

resource "vault_pki_secret_backend_config_ca" "this" {
	backend = vault_mount.pki.path
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

resource "vault_pki_secret_backend_intermediate_cert_request" "this" {
 backend      = vault_mount.pki.path
 type         = "internal"
 common_name  = "GCVE Vault Intermediate"
 key_type     = "ec"
 key_bits     = "384"
 organization = "WWTFO"
 ou           = "TFO_APJ_DEMOS"
 country      = "AU"
 locality     = "Sydney"
}
/*
resource "vault_pki_secret_backend_role" "gcve" {
	name = "gcve"
	backend = vault_mount.pki.path
	max_ttl = "259200"
	ttl = "259200"
	allowed_domains = [
		"hashicorp.local"
	]
	allowed_uri_sans = [
		"*.hashicorp.local",
	]
	allow_ip_sans = true
	allow_subdomains = true
	enforce_hostnames = false
}*/