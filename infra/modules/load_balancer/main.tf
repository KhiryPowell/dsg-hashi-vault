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

resource "azurerm_lb_rule" "vault_webrule" {
  loadbalancer_id                = azurerm_lb.vault_lb.id
  name                           = "vault-webrule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 8200
  frontend_ip_configuration_name = "vault-frontend"
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.vault_backend.id]
  probe_id = azurerm_lb_probe.health_probe.id
  enable_floating_ip = false
  idle_timeout_in_minutes = 4
  disable_outbound_snat = false
}

resource "azurerm_lb_probe" "health_probe" {
  loadbalancer_id = azurerm_lb.vault_lb.id
  name            = "vault-health-probe"
  port            = 8200
  protocol        = "Http"
  probe_threshold = 1
  request_path = "/sys/health"
  interval_in_seconds = 15
  number_of_probes = 2
}