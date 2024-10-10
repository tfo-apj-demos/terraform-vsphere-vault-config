terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5"
    }
    time = {
      source = "hashicorp/time"
      version = "0.12.1"
    }
  }
  cloud {
    organization = "tfo-apj-demos"
    workspaces {
      name = "vault-config"
    }
  }
}
