terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.18"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.27"
    }
  }
}


resource "azurerm_network_security_group" "vaultnsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}