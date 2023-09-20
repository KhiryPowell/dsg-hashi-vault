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


resource "azurerm_lb" "vault_lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = "vault-frontend"
    private_ip_address   = var.private_ip_address
    private_ip_address_allocation = "Static"
    subnet_id = var.subnet_id
  }
}

resource "azurerm_lb_backend_address_pool" "vault_backend" {
  loadbalancer_id = azurerm_lb.vault_lb.id
  name            = "vault-backendaddresspool"
}