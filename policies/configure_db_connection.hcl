path "postgres/config/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt.accessor}.name}}-*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete"
  ]
}

path "postgres/roles/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt.accessor}.name}}-*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete"
  ]
}

path "postgres/rotate-root/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt.accessor}.name}}-*" {
  capabilities = [
    "update"
  ]
}

