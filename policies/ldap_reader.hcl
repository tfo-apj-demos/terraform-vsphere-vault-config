# --- Read GCVE credentials from LDAP engine
path "ldap/creds/+" {
  capabilities = ["read"]
}

# --- List and read roles in the LDAP secret engine
path "ldap/role" {
  capabilities = ["list"]
}

path "ldap/role/+" {
  capabilities = ["read", "list"]
}

# --- Read and write static roles in the LDAP secret engine
path "ldap/static-role/+" {
  capabilities = ["read", "list", "create", "update", "delete"]
}

# --- Fetch static role credentials
path "ldap/static-cred/+" {
  capabilities = ["read", "list"]
}

# --- Read and write library sets in the LDAP secret engine
path "ldap/library-set/+" {
  capabilities = ["read", "list", "create", "update", "delete"]
}

# --- Read the configuration of the LDAP secret engine
path "ldap/config" {
  capabilities = ["read"]
}

# --- List and read the entire LDAP secret engine configuration
path "ldap/config/*" {
  capabilities = ["read", "list"]
}
