# --- Create token with permissions to read LDAP
path "auth/token/create" {
	capabilities = [
    "create", 
    "read", 
    "update", 
    "delete"
  ]
}