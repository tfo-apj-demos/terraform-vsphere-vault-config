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