terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.90.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "**Subscription Id**"
  tenant_id       = "**Tenent Id**"
  client_id       = "**Client Id**"
  client_secret   = "**Client Secret**"
  features {
  }
}
