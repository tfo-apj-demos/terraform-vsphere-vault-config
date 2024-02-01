path "postgres/config/{{identity.entity.aliases.auth_jwt_18abb2d6.name}}-*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete"
  ]
}

path "postgres/roles/{{identity.entity.aliases.auth_jwt_18abb2d6.name}}-*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete"
  ]
}

path "postgres/rotate-root/{{identity.entity.aliases.auth_jwt_18abb2d6.name}}-*" {
  capabilities = [
    "update"
  ]
}

