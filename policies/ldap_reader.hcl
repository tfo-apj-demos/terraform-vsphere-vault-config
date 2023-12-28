# --- Read GCVE credentials from LDAP engine
path "ldap/creds/+" {
	capabilities = [
    "read"
  ]
}

path "ldap/role" {
	capabilities = [
    "list"
  ]
}

path "ldap/role/+" {
	capabilities = [
    "read"
  ]
}