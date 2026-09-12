terraform {
  backend "azurerm" {
    resource_group_name  = "NorthStar-Landing-Zone-RG"
    storage_account_name = "northstartfstate244d"
    container_name       = "tfstate"
    key                  = "northstar-secure-azure-landing-zone.tfstate"
    use_azuread_auth     = true
  }
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


provider "azuread" {}
