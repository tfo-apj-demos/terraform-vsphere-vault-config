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

variable "ldap_url" {
  description = "URL for LDAP connection"
  type        = string
}

variable "ldap_insecure_tls" {
  description = "Flag to specify if TLS is insecure"
  type        = bool
}

variable "ldap_userdn" {
  description = "DN of users for LDAP"
  type        = string
}

variable "ldap_role_name" {
  description = "Name of the LDAP role"
  type        = string
}

variable "ldap_creation_ldif" {
  description = "LDIF template used to create a user account"
  type        = string
}

variable "ldap_deletion_ldif" {
  description = "LDIF template used to delete a user account"
  type        = string
}

variable "ldap_rollback_ldif" {
  description = "LDIF template used to rollback changes on error"
  type        = string
}
