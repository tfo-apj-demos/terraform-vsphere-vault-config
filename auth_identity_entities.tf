locals {
  github_usernames = toset(data.tfe_outputs.github_identities.values.github_usernames)
}

data "tfe_outputs" "github_identities" {
  organization = var.tfc_organization
  workspace = var.tfc_workspace
}

# --- Create entities for the SEs, and aliases for OIDC auth.
resource "vault_identity_entity_alias" "se" {
  for_each = vault_identity_entity.se
  name = each.value.name
  mount_accessor = vault_jwt_auth_backend.this.accessor
  canonical_id = each.value.id
}

resource "vault_identity_entity" "se" {
  for_each = nonsensitive(local.github_usernames)
  name = each.value
}

# --- Create external groups based on OIDC group claims.
resource "vault_identity_group" "team_se" {
  type = "external"
  name = "team-se"
}

resource "vault_identity_group_alias" "team_se" {
  name           = "team-se"
  mount_accessor = vault_jwt_auth_backend.this.accessor
  canonical_id   = vault_identity_group.team_se.id
}

resource "vault_identity_group" "gcve_admins" {
  type = "external"
  name = "gcve-admins"
  policies = [
    "admin"
  ]
}

resource "vault_identity_group_alias" "gcve_admins" {
  name           = "gcve-admins"
  mount_accessor = vault_jwt_auth_backend.this.accessor
  canonical_id   = vault_identity_group.gcve_admins.id
}