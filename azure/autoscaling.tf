resource "azurerm_linux_virtual_machine_scale_set" "test-vmss" {
  name                            = join("-", [var.environment, var.vmss_name])
  resource_group_name             = azurerm_resource_group.test-rg.name
  location                        = azurerm_resource_group.test-rg.location
  sku                             = var.vmss_sku
  instances                       = var.instance_count
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  source_image_id = var.source_image_id
  upgrade_mode = var.upgrade_mode
  health_probe_id = azurerm_lb_probe.lb_probe.id
  network_interface {
    name    = join("-", [var.environment, var.vmss_net_interface])
    primary = true

    ip_configuration {
      name      = join("-", [var.environment, var.vmss_ip_config])
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
      subnet_id = azurerm_subnet.test-subnet.id
    }
  }
  os_disk {
    storage_account_type = var.storage_account_type
    caching              = var.caching
  }
  depends_on = [
    azurerm_lb_rule.lb_rule
  ]
  tags = {
    "Name" = join("-", [var.environment, var.vmss_name])
  }
}
resource "azurerm_monitor_autoscale_setting" "test-auto-set" {
  name                = join("-", [var.environment, var.autoscaling_setting])
  resource_group_name = azurerm_resource_group.test-rg.name
  location            = azurerm_resource_group.test-rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.test-vmss.id
  profile {
    name = join("-", [var.environment, var.autoscaling_profile_name])
    capacity {
      default = var.default_instance_count
      minimum = var.minimum_instance_count
      maximum = var.maximum_instance_count
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.test-vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.test-vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
  tags = {
    "Name" = join("-", [var.environment, var.autoscaling_setting])
  }
}