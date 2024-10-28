terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.8.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "aztf-backend-rg"
    storage_account_name = "aztfsandbox63"
    container_name       = "terraform"
    key                  = "tfstate"
    use_oidc             = true
    subscription_id      = var.hub_state_sub_id
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

provider "azurerm" {
  alias = "spoke"
  features {}
  use_oidc = true
}

provider "azurerm" {
  alias = "hub"
  features {}
  use_oidc        = true
  subscription_id = var.hub_subscription_id
}