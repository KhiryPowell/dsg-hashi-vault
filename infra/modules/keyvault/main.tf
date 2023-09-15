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

resource "azurerm_key_vault" "vault_kv" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = "e04b15c8-7a1e-4390-9b5b-28c7c205a233"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  enabled_for_deployment      = true
  tags                        = var.tags
  network_acls {
    default_action = var.network_acls.default_action
    bypass = var.network_acls.bypass
    ip_rules = var.network_acls.ip_rules
    virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
  }
}