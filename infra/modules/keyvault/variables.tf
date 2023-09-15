variable "key_vault_name" {
  description = "The name of the key vault. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "The location to create resources."
  type        = string
  default     = "eastus"
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

variable "network_acls" {
 description = "Network ACL configuration for the Azure Key Vault"
 type        = object({
   default_action = string
   bypass         = string
   ip_rules       = list(string)
   virtual_network_subnet_ids = list(string)
 })
 default = {
   default_action = "Deny"
   bypass         = "AzureServices"
   ip_rules       = []
   virtual_network_subnet_ids = []
 }
}