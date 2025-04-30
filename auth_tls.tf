resource "vault_auth_backend" "cert" {
  type = "cert"
  path = "cert"
}

data "local_file" "intermediate_cert" {
  filename = "${path.root}/ca_cert_dir/intermediate.pem"
}

data "local_file" "ca_chain" {
  filename = "${path.root}/ca_cert_dir/ca_chain.pem"
}

resource "vault_cert_auth_backend_role" "client-cert-auth" {
  backend              = vault_auth_backend.cert.path
  name                 = "client-cert-auth"
  display_name         = "Client Cert Auth Role"
  certificate          = data.local_file.ca_chain.content
}