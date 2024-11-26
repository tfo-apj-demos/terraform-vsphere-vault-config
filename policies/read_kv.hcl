#Path to access kv secrets
path "secrets/*" {
    capabilities = [
      "list",
      "read"
    ]
}

path "secrets/data/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}