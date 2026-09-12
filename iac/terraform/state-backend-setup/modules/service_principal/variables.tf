variable "env" {
     type = string
     default = "dev" 
     }

variable "owner_id" {
  type        = string
  description = "(Optional) Object ID of owner to be assigned to service principal. Assigned to current user if not set."
  default     = null
}
variable "tags" {
  type = map(string)

  default = {
    environment = "dev"
  }
}

variable "identity_name" {
  type        = string
  description = "(optional) Name of application and service principal."
  default = "null"
}
#################
variable "RBAC_name" {
  type = string
  default = "null"
}
variable "is_custom_RBAC" {
  type = bool
  default = true
}
variable "description" {
  type    = string
}
#################
variable "role_assignment_scope" {
  type        = string
  description = "must be equal to, or a child of, one of the `assignable_scopes`"
}
variable "assignable_scopes" {
  type        = list(string)
  description = "list of scopes where the custom role is legally permitted to be assigned"
}
variable "role_definition_scope" {
  type        = string
  description = "where the custom RBAC  is **stored and managed** within the Azure,  be anchored to a Management Group or Subscription"
}
variable "condition_tpl_vars" {
  type = map(string)
  default = null
}
variable "condition_tpl" {
  type        = string
  description = "condition.tpl in the conditions folder (custom ABAC condition) "
  default = null
}
variable "buildIn_role_definition_name" {
  type = string
  description = "i.e. Storage Blob Data Contributor"
  default = "null"
  
}