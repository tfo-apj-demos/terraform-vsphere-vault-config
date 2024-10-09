output "ca_chain_certificate" {
  value       = file("${path.module}/ca_cert_dir/ca_chain.pem")
  description = "The content of the CA certificate."
}

output "approle_ansible" {
  value       = vault_approle_auth_backend_role_secret_id.id.secret_id
  description = "The role_id for the approle ansible."
  sensitive = true
}