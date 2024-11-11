# Policy for rotating and deleting AppRole secret_id and accessor
path "auth/approle/role/ansible/secret-id" {
  capabilities = ["create", "update", "read", "list", "sudo" ]
}

# path "auth/approle/role/ansible/secret-id-accessor/*" {
#   capabilities = ["list", "read", "update", "delete"]
# }