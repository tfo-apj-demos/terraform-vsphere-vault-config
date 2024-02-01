path "postgres/config/{{identity.entity.name}}-*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete"
  ]
}

path "postgres/roles/{{identity.entity.name}}-*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete"
  ]
}

path "potgres/rotate-root/{{identity.entity.name}}-*" {
  capabilities = [
    "update"
  ]
}