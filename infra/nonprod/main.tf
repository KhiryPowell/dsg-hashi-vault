terraform {
  backend "azurerm" {
    subscription_id      = "76179119-b4b3-4a0d-98fc-bbfe558fa78b"
    resource_group_name  = "rg-terraform-oss-p"
    storage_account_name = "stdsgtfosspue"
    container_name       = "sc-vault-np"
    key                  = "vault-np.tfstate"
  }
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.27"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.18"
    }
  }
}

provider "azurerm" {
  subscription_id = "3a085d52-0c96-485f-b679-9441a67ed4a2" #sub-devtools-nonprod-1
  features {}
}



