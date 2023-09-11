variable "ip_range_filter" {
  description = "List of public ip ranges to allow access. Example: [\"199.30.192.0/22\"]"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "The name of the storage account. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Example: eastus"
  type        = string
}

variable "firewall_subnet_ids" {
  description = "List of subnet IDs to be added to the firewall VNET rules. Example: [\"/subscriptions/SUBSCRIPTION-ID/resourceGroups/RG-NAME/providers/Microsoft.Network/virtualNetworks/VNET-NAME/subnets/SNET-NAME\"]"
  type        = list(string)
  default     = []
}

variable "firewall_tags" {
  description = "Firewall Tags as specified in https://confluence.dcsg.com/display/STADE/PCF+Firewall+Rules+-+Overview. Example: [\"NP-PCF-PAS\",\"CLIENT-VPN\"]"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Dictionary of tags to associate to the resource. Example: tags = {\"Owner\" = \"your-team-distro@dcsg.com\" \"CostCenter\"  = 12345}. https://github.com/dsg-tech/ccoe/blob/master/articles/Tagging.md"
  type        = map(string)
}