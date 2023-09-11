
variable "location" {
  description = "The location to create resources."
  type        = string
  default     = "eastus"
}

variable "name" {
  description = "The name of the storage account. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  type        = string
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}