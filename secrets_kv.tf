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