terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
  cloud {
    organization = "tfo-apj-demos"
    workspaces {
      name = "vault-config"
    }
  }
}

