resource "vault_auth_backend" "cert" {
  type = "cert"
  path = "cert"
}

data "local_file" "root_ca_cert" {
  filename = "${path.root}/ca_cert_dir/root_ca.pem"
}

resource "vault_cert_auth_backend_role" "client-cert-auth" {
  backend              = vault_auth_backend.cert.path
  name                 = "client-cert-auth"
  display_name         = "Client Cert Auth Role"
  certificate          = data.local_file.root_ca_cert.content
  allowed_common_names = ["*"]
}