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