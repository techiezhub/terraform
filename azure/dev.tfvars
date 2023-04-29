environment = "test"
resource_group_name = "rg"
location = "Central India"
virtual_network_name = "vnet"
virtual_network_cidr = ["10.0.0.0/16"]
subnet_name = "subent1"
subnet_cidr = ["10.0.1.0/24"]
nsg_name = "webserver-nsg"
vmss_name = "webserver-vmss"
vmss_sku = "Standard_B1s"
instance_count = 1
admin_username = "adminuser"
admin_password = "P@ssw0rd1234!"
disable_password_authentication = false
source_image_id = "/subscriptions/ade650db-dbf8-4b32-bdc3-ea79b0d6841f/resourceGroups/test-int/providers/Microsoft.Compute/images/test-image-20230427173505"
upgrade_mode = "Automatic"
vmss_net_interface = "networkinterface"
vmss_ip_config = "ipconfiguration"
storage_account_type = "Standard_LRS"
caching              = "ReadWrite"
autoscaling_setting = "webserver_autoscaling_config"
autoscaling_profile_name = "webserver_autoscaling_profile"
default_instance_count = "1"
minimum_instance_count = "1"
maximum_instance_count = "5"
lb_pub_ip = "webserver_lb_pub_ip"
lb_ip_allocation_method = "Static"
lb_ip_sku = "Standard"
lb_name = "webserver_lb"
lb_sku = "Standard"
lb_frontend_config_name = "webserver_lb_frontend_config"
lb_backendpool_name = "webserver_lb_backendpool"
lb_rule_name = "webserver_lb_rule"
lb_rule_protocol = "Tcp"
lb_rule_frontend_port = 80
lb_rule_backend_port = 8080
lb_rule_enable_floating_ip = false
lb_rule_idle_timeout_in_minutes = 5
lb_probe_name = "webserver_lb_probe"
lb_probe_protocol = "Http"
lb_probe_port = 8080
lb_probe_request_path = "/"
lb_probe_interval_in_seconds = 5
lb_probe_number_of_probes = 2


























