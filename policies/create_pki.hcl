path "pki/*" {
  capabilities = ["read", "list"]
}

path "pki/intermediate/set-signed" {
    capabilities = ["update"]
}
path "pki/sign/gcve" {
  capabilities = ["create", "read"]
}

path "pki/issue/gcve" {
  capabilities = ["create"]
}
