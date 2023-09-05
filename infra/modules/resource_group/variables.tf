variable "workload_name" {
  description = "The resource group root name not including prefix or suffix."
  type        = string
}

variable "location" {
  description = "The location to create resources."
  type        = string
  default     = "eastus"
}

variable "env" {
  description = "Environment."
  type        = string
}

variable "service_principal_id" {
  description = "Service Principal ID."
  type        = string
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "team_group" {
  description = "The AD group for the team."
  type        = string
}