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
