resource "azurerm_resource_group" "test-rg" {
  name     = join("-", [var.environment, var.resource_group_name]) 
  location = var.location
  tags = {
    "Name" = join("-", [var.environment, var.resource_group_name])
  }
}