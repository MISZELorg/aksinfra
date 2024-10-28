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
    subscription_id      = "2745b794-365d-4993-9eec-fe3f9879434b"
    tenant_id            = "48c383d8-47c5-48f9-9e8b-afe4f2519054"
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = [
    "Microsoft.Network",
    "Microsoft.Compute",
    "Microsoft.Storage"
  ]
}

provider "azurerm" {
  alias = "spoke"
  features {}
  resource_provider_registrations = [
    "Microsoft.Network",
    "Microsoft.Compute",
    "Microsoft.Storage"
  ]
}

provider "azurerm" {
  alias = "hub"
  features {}
  resource_provider_registrations = [
    "Microsoft.Network",
    "Microsoft.Compute",
    "Microsoft.Storage"
  ]
  subscription_id = var.hub_sub_id
}