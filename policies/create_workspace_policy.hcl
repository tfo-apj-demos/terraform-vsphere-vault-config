path "/sys/policies/{{identity.entity.aliases.auth_jwt_18abb2d6.name}}-*" {
  capabilities = ["create", "read", "update", "delete"]
}

path "/sys/policies/acl/{{identity.entity.aliases.auth_jwt_18abb2d6.name}}-*" {
  capabilities = ["create", "read", "update", "delete"]
}