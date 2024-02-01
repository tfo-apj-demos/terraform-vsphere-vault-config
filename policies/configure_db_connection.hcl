path "postgres/config/{{identity.entity.aliases.database_fc9eb6d8.name}}-*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete"
  ]
}

path "postgres/roles/{{identity.entity.aliases.database_fc9eb6d8.name}}-*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete"
  ]
}

path "postgres/rotate-root/{{identity.entity.aliases.database_fc9eb6d8.name}}-*" {
  capabilities = [
    "update"
  ]
}

