output "ca_chain_certificate" {
  value       = file("${path.module}/ca_cert_dir/ca_chain.pem")
  description = "The content of the CA certificate."
}

# output "ansible_secret_id" {
#   value       = nonsensitive(vault_approle_auth_backend_role_secret_id.id.secret_id)
#   description = "The secret_id for the approle ansible."
# }

# output "ansible_role_id" {
#   value       = nonsensitive(vault_approle_auth_backend_role.ansible.role_id)
#   description = "The role_id for the approle ansible."
# }