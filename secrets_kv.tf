resource "vault_mount" "this" {
  path        = "secrets"
  type        = "kv"
  options     = { version = "2" }
}

resource "vault_mount" "hostnaming" {
  path        = "hostnaming"
  type        = "kv"
  options     = { version = "2" }
  description = "Key/Value mount for generating hostnames for virtual machines"
}

resource "vault_mount" "djoo-kv-demo" {
  path        = "kv-demo"
  type        = "kv"
  options     = { version = "2" }
  description = "djoo kv demo"
}

resource "vault_kv_secret_v2" "djoo_secret" {
  mount = vault_mount.djoo-kv-demo.path
  name  = "djoo"
  data_json = jsonencode(
    {
      api_cred = "aaaa-bbbb-cccc-dddd"
    }
  )
}