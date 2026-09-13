resource "azurerm_public_ip" "gateway" {
  name                = "northstar-lz-gateway-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_application_gateway" "northstar" {
  name                = "northstar-lz-app-gateway"
  resource_group_name = var.resource_group_name
  location            = var.location
  firewall_policy_id  = azurerm_web_application_firewall_policy.northstar.id
  tags                = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.application_gateway.id]
  }

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "waf-subnet"
    subnet_id = var.waf_subnet_id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_port {
    name = "https"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "public"
    public_ip_address_id = azurerm_public_ip.gateway.id
  }

  ssl_certificate {
    name                = "northstar-key-vault-tls"
    key_vault_secret_id = "${azurerm_key_vault.northstar.vault_uri}secrets/northstar-tls"
  }

  backend_address_pool {
    name  = "app-service-backend"
    fqdns = [azurerm_linux_web_app.web.default_hostname]
  }

  probe {
    name                                      = "app-service-https"
    protocol                                  = "Https"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }

  backend_http_settings {
    name                                = "app-service-https"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 30
    pick_host_name_from_backend_address = true
    probe_name                          = "app-service-https"
  }

  http_listener {
    name                           = "public-http"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "public-https"
    frontend_ip_configuration_name = "public"
    frontend_port_name             = "https"
    protocol                       = "Https"
    ssl_certificate_name           = "northstar-key-vault-tls"
    host_name                      = "northstar.guydiangana.com"
    require_sni                    = true
  }

  redirect_configuration {
    name                 = "http-to-https"
    redirect_type        = "Permanent"
    target_listener_name = "public-https"
    include_path         = true
    include_query_string = true
  }

  request_routing_rule {
    name                        = "redirect-http-to-https"
    rule_type                   = "Basic"
    http_listener_name          = "public-http"
    redirect_configuration_name = "http-to-https"
    priority                    = 100
  }

  request_routing_rule {
    name                       = "route-https-to-app-service"
    rule_type                  = "Basic"
    http_listener_name         = "public-https"
    backend_address_pool_name  = "app-service-backend"
    backend_http_settings_name = "app-service-https"
    priority                   = 110
  }
}
