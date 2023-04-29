terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.50.0"
    }
  }
}
provider "azurerm" {
  features {}
#   subscription_id = "ade650db-dbf8-4b32-bdc3-ea79b0d6841f"
#   client_id       = "ade8035d-1af3-4a1f-81eb-1876722b399a"
#   client_secret   = "6Ev8Q~QmAuEgW-tdZgW2j1yREk5Frmfq0QnvNauH"
#   tenant_id       = "a228435f-ce0d-4227-9a4c-8f5f4c15b5a1"
#   subscription_id = "ade650db-dbf8-4b32-bdc3-ea79b0d6841f"
}