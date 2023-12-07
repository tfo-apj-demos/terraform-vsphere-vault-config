resource "vault_policy" "create_child_token" {
  name   = "create_child_token"
  policy = file("./policies/create_child_token.hcl")
}