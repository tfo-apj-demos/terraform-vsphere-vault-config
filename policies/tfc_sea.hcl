# --- Create role for TFC
path "auth/jwt/role/{{identity.entity.name}}" {
    capabilities = [
      "create",
      "read",
      "update",
      "delete",
      "list"
    ]
}
