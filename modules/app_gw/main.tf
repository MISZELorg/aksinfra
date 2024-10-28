locals {
  backend_address_pool_name      = "${var.virtual_network_name}-beap"
  frontend_port_name             = "${var.virtual_network_name}-feport"
  frontend_ip_configuration_name = "${var.virtual_network_name}-feip"
  http_setting_name              = "${var.virtual_network_name}-be-htst"
  listener_name                  = "${var.virtual_network_name}-httplstn"
  request_routing_rule_name      = "${var.virtual_network_name}-rqrt"
  redirect_configuration_name    = "${var.virtual_network_name}-rdrcfg"
}

resource "azurerm_application_gateway" "agw" {
  name                = var.appgw_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "app-gateway-ip-configuration"
    subnet_id = var.frontend_subnet
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  #   frontend_port {
  #     name     = "https-443"
  #     port     = 443
  #   }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = var.appgw_pip
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 1 //priority arguement required as of 3.6.0 release. 1 is the highest priority and 20000 is the lowest priority.
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection" # "Prevention" or "Detection"
    rule_set_type    = "OWASP"     # "OWASP" or "Microsoft_BotManagerRuleSet"
    rule_set_version = "3.2"
  }
}