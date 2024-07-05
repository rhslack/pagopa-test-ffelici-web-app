terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }

  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

provider "azuredevops" {
  # Configuration options
}

data "azurerm_client_config" "current" {}