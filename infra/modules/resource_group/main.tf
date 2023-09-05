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

data "azuread_group" "team" {
  display_name     = var.team_group
  security_enabled = true
}

module "tf_tagging" {
  source  = "git@github.com:dsg-tech/terraform-dsg-azure-tagging.git"
  
  user_tags = var.tags
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.workload_name}-${var.env}"
  location = var.location

  tags = module.tf_tagging.tags

  # commenting, because tag requirements may change with module updates.. but not ignoring tags has been a nuisance in the past, so we'll see how it goes.
  # lifecycle {
  #   ignore_changes = [
  #     tags
  #   ]
  # }
}

resource "azurerm_role_assignment" "sp" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "DSG Deployer"
  principal_id         = var.service_principal_id
}

resource "azurerm_role_assignment" "team" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = var.env == "np" || var.env == "sbx" ? "DSG Deployer" : "DSG Reader"
  principal_id         = data.azuread_group.team.object_id
}

data "azurerm_policy_definition" "dsg_deny_principal" {
  name = "deny_principal_assignment_on_scope"
  management_group_name = "mg-dsg"
}

resource "azurerm_resource_group_policy_assignment" "rg_dsg_deny_principal" {
  name                 = "dsg_rg_deny_principal"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = data.azurerm_policy_definition.dsg_deny_principal.id
}
