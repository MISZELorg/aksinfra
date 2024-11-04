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
    subscription_id      = "2745b794-365d-4993-9eec-fe3f9879434b"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# Use if our SPN is allowed to create EID groups.
provider "azuread" {
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