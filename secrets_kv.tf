resource "vault_mount" "this" {
  path        = "secrets"
  type        = "kv"
  options     = { version = "2" }
}
resource "vault_kv_secret_v2" "api_creds" {
  mount = vault_mount.this.path
  name  = "dev"
  data_json = jsonencode(
    {
      api_cred = "aaaa-bbbb-cccc-dddd"
    }
  )
}

# RHEL Subscription Manager credentials for VM registration
resource "vault_kv_secret_v2" "rhel_subscription" {
  mount = vault_mount.this.path
  name  = "rhel/subscription"

  data_json = jsonencode({
    rhn_username = "PLACEHOLDER"
    rhn_password = "PLACEHOLDER"
  })

  lifecycle {
    ignore_changes = [data_json]
  }
}

# ServiceNow dev instance — read by the snow_drift_tickets role
# (playbooks/drift-create-snow-tickets.yml) when EDA fires the drift
# workflow. Real values populated manually in the Vault UI; Terraform
# only owns the path + initial placeholder.
resource "vault_kv_secret_v2" "servicenow_dev" {
  mount = vault_mount.this.path
  name  = "servicenow/dev"

  data_json = jsonencode({
    username = "PLACEHOLDER"
    password = "PLACEHOLDER"
  })

  lifecycle {
    ignore_changes = [data_json]
  }
}

# HCP Terraform user/team token — read by the tfc_trigger_apply role
# (playbooks/tfc-trigger-apply.yml) when EDA fires the remediation
# apply after a ServiceNow CR approval. Token needs workspace:write
# and run:create on the target workspaces.
resource "vault_kv_secret_v2" "tfc_api" {
  mount = vault_mount.this.path
  name  = "tfc/api"

  data_json = jsonencode({
    token = "PLACEHOLDER"
  })

  lifecycle {
    ignore_changes = [data_json]
  }
}