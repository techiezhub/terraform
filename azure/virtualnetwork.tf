resource "azurerm_virtual_network" "test-vnet" {
  name                = join("-", [var.environment, var.virtual_network_name])
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
  address_space       = var.virtual_network_cidr
  tags = {
    Name = join("-", [var.environment, var.virtual_network_name])
  }
}
resource "azurerm_subnet" "test-subnet" {
  name = join("-", [var.environment, var.subnet_name])
  resource_group_name = azurerm_resource_group.test-rg.name 
  address_prefixes = var.subnet_cidr
  virtual_network_name = azurerm_virtual_network.test-vnet.name
}
resource "azurerm_network_security_group" "test-nsg" {
  name                = join("-", [var.environment, var.nsg_name])
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name

  security_rule {
    name                       = "allowport80"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allowport8080"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    Name = join("-", [var.environment, var.nsg_name])
  }
}
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.test-subnet.id
  network_security_group_id = azurerm_network_security_group.test-nsg.id
}