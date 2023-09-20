variable "lb_name" {
  description = "Specifies the name of the Load Balancer. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure Region where the Load Balancer should be created. Changing this forces a new resource to be created."
  type        = string
  default     = "eastus"
}

variable "private_ip_address" {
  description = "Private IP Address to assign to the Load Balancer. The last one and first four IPs in any range are reserved and cannot be manually assigned."
  type        = string  
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the Subnet which should be associated with the IP Configuration."
  type = string
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}
