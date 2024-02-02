resource "vault_mount" "postgres" {
  path = "postgres"
  type = "database"
}

# --- Note that all connections and roles are configured through self service.