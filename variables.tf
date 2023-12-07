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
  default = [ {
    role_name   = "test"
    group_names = ["a","b"]
  } ]
}


