resource "vault_database_secrets_mount" "postgres" {
  path = "postgres"
}

# --- Note that all connections and roles are configured through self service.