terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }

  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

# data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}


provider "random" {
  # Configuration options
}

