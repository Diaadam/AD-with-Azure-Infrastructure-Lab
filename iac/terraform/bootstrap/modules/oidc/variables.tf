variable "repository_name" {
  type        = string
  description = "(Required) Name of the repository in the form (org | user)/repository example:"

  validation {
      condition     = length(split("/", var.repository_name)) == 2
      error_message = "Repository name must contain exactly one '/' separating the owner and repository name, optionally including immutable IDs."
    }
}

variable "entity_type" {
  type        = string
  description = "(Required) Type of entity for federation. Can be environment, ref (ref_branches or ref_tags), pull_request, tag"

  validation {
    condition     = contains(["environment", "ref", "pull_request"], var.entity_type)
    error_message = "The entity_type must be one of the following: environment, ref, pull_request."
  }
}

variable "create_pr_identity" {
  type        = bool
  description = "(Optional) Whether to create a pull request federated identity in addition to other identities. Defaults to false."
  default     = false
}

variable "environment_names" {
  type        = list(string)
  description = "(Optional) Name of environment entities. Required if entity_type is environment."
  default     = []
}

variable "ref_branches" {
  type        = list(string)
  description = "(Optional) Name of branches to use with ref entity. Required if entity_type is ref and branch is the target."
  default     = []
}

variable "ref_tags" {
  type        = list(string)
  description = "(Optional) Name of tags to use with ref entity. Required if entity_type is ref and tag is the target."
  default     = []
}

variable "owner_id" {
  type        = string
  description = "(Optional) Object ID of owner to be assigned to service principal. Assigned to current user if not set."
  default     = null
}

variable "azuread_application_id" {
  type = string
}
variable "azuread_application_display_name" {
  type = string
}