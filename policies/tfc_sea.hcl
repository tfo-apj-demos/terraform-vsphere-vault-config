# --- Create role for TFC
path "/jwt/role/{{identity.entity.name}}" {
    capabilities = [
      "create",
      "read",
      "update",
      "delete"
    ]
    // allowed_parameters = {
    //   role_type  = "jwt",
    //   bound_claims_type = "glob",
    //   user_claim = []
    //   bound_claims = []
    //   claim_mappings = []
    //   token_policies = [
    //     "create_child_token",
    //     "ldap_reader"
    //   ]
    // }
    // denied_parameters = {
    //   policies = []
    // }
}
