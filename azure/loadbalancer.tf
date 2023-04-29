resource "azurerm_public_ip" "lbpip" {
  name                = join("-", [var.environment, var.lb_pub_ip])
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
  allocation_method   = var.lb_ip_allocation_method
  sku = var.lb_ip_sku
  tags = {
    "Name" = join("-", [var.environment, var.lb_pub_ip])
  }
}
resource "azurerm_lb" "lb" {
  name                = join("-", [var.environment, var.lb_name])  
  resource_group_name = azurerm_resource_group.test-rg.name
  location            = azurerm_resource_group.test-rg.location
  sku = var.lb_sku
  frontend_ip_configuration {
    name                 = join("-", [var.environment, var.lb_frontend_config_name])
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
  tags = {
    "Name" = join("-", [var.environment, var.lb_name])
  }
}
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = join("-", [var.environment, var.lb_backendpool_name])
  loadbalancer_id = azurerm_lb.lb.id
}
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = join("-", [var.environment, var.lb_rule_name])
  protocol                       = var.lb_rule_protocol
  frontend_port                  = var.lb_rule_frontend_port
  backend_port                   = var.lb_rule_backend_port
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  enable_floating_ip             = var.lb_rule_enable_floating_ip
  idle_timeout_in_minutes        = var.lb_rule_idle_timeout_in_minutes
  probe_id                       = azurerm_lb_probe.lb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
}
resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = var.lb_probe_name
  protocol            = var.lb_probe_protocol
  port                = var.lb_probe_port
  request_path        = var.lb_probe_request_path
  interval_in_seconds = var.lb_probe_interval_in_seconds
  number_of_probes    = var.lb_probe_number_of_probes
}