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

locals {
  ip_range_filter = distinct(flatten(concat([
    for ip_range in var.ip_range_filter :
    tonumber(split("/", ip_range)[1]) == 32 ? [split("/", ip_range)[0]] :
    tonumber(split("/", ip_range)[1]) == 31 ? [cidrhost(ip_range, 0), cidrhost(ip_range, 1)] : [ip_range]
  ])))

}

module "firewall_lookup" {
  source = "git@github.com:dsg-tech/terraform-dsg-azure-platform-firewall-lookup.git"

  firewall_tags      = var.firewall_tags
  source_region      = var.location
  expand_small_cidrs = true
}

resource "azurerm_storage_account" "stg" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  account_tier                     = "Standard"
  account_replication_type         = "GRS"
  account_kind                     = "StorageV2"
  access_tier                      = "Hot"
  enable_https_traffic_only        = true
  min_tls_version                  = "TLS1_2"
  cross_tenant_replication_enabled = false
  public_network_access_enabled    = true
  allow_nested_items_to_be_public  = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 365
    }
    container_delete_retention_policy {
      days = 365
    }
  }

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    ip_rules                   = concat(local.ip_range_filter, module.firewall_lookup.ip_ranges)
    virtual_network_subnet_ids = concat(var.firewall_subnet_ids, module.firewall_lookup.subnet_ids)
  }

  tags = var.tags
}