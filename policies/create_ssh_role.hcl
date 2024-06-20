path "ssh/roles/{{identity.entity.aliases.auth_jwt_18abb2d6.name}}-*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "ssh/roles/*" {
  capabilities = ["create", "read", "update", "delete"]
}