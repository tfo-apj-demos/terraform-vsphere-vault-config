variable "ldap_url" {
  description = "url for the LDAP connection"
  type        = string
}

variable "ldap_path" {
  description = "The path for the LDAP backend"
  type        = string
}

variable "ldap_binddn" {
  description = "Bind DN for LDAP"
  type        = string
}

variable "ldap_bindpass" {
  description = "Password for bind DN"
  type        = string
  sensitive   = true
}

variable "ldap_userdn" {
  description = "DN of users for LDAP"
  type        = string
}

variable "ldap_roles" {
  description = "An object containing the role name and Active Directory groups to join."
  type = list(object({
    role_name   = string
    group_names = list(string)
  }))
}

variable "ldap_groupdn" {
  description = "DN of group for LDAP"
  type        = string
}

variable "oidc_client_secret" {
  type = string
}

variable "domain_admin_password" {
  description = "Password for domain admin"
  type        = string
  sensitive   = true
}

variable "tfc_organization" {
  type    = string
  default = "tfo-apj-demos"
}

variable "tfc_workspace" {
  type    = string
  default = "github-identities"
}

variable "pki_root_path" {
  description = "Path for the Root PKI secret engine mount"
  type        = string
  default     = "demo-pki-root"
}

variable "pki_intermediate_path" {
  description = "Path for the Intermediate PKI secret engine mount"
  type        = string
  default     = "demo-pki-intermediate"
}

variable "default_lease_ttl" {
  description = "Default lease TTL in seconds"
  type        = number
  default     = 63113904
}

variable "max_lease_ttl" {
  description = "Max lease TTL in seconds"
  type        = number
  default     = 63113904
}

variable "root_ca_common_name" {
  description = "Common name for the Root CA"
  type        = string
  default     = "Root CA Vault PKI Demo"
}

variable "intermediate_ca_common_name" {
  description = "Common name for the Intermediate CA"
  type        = string
  default     = "SubOrg Intermediate CA"
}

variable "pki_key_bits" {
  description = "Number of bits for the key"
  type        = number
  default     = 4096
}

variable "pki_ttl" {
  description = "Time-to-live for the certificate"
  type        = string
  default     = "31556952"
}

variable "organization" {
  description = "Organization name"
  type        = string
  default     = "tfo-apj-demos"
}

variable "ou" {
  description = "Organizational Unit"
  type        = string
  default     = "Solutions Engineering & Architecture"
}

variable "country" {
  description = "Country code"
  type        = string
  default     = "AU"
}

variable "locality" {
  description = "Locality or city name"
  type        = string
  default     = "Sydney"
}

variable "province" {
  description = "Province or state name"
  type        = string
  default     = "NSW"
}

variable "role_name" {
  description = "Name of the role"
  type        = string
  default     = "my_role"
}

variable "allowed_domains" {
  description = "List of allowed domains for the role"
  type        = list(string)
  default     = ["hashicorp.local"]
}

variable "max_ttl" {
  description = "Maximum TTL for the role"
  type        = number
  default     = 180
}

variable "external_root_ca_url" {
  description = "URL of the external Root CA's issuing certificate endpoint"
  type        = string
  default     = "https://production.vault.11eb56d6-0f95-3a99-a33c-0242ac110007.aws.hashicorp.cloud:8200/v1/pki"
}

variable "kubernetes_api" {
  type        = string
  description = "kubernetes control plane"
}

variable "kubernetes_ca_cert" {
  type        = string
  description = "kubernetes cluster certificate"
}

variable "token_reviewer_jwt" {
  type        = string
  description = "json web token"
}