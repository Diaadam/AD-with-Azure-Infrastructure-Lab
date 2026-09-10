variable "name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
  default = "UAE North"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags."
  default     = {}
}
