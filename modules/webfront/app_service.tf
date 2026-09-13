resource "azurerm_service_plan" "web" {
  name                = "northstar-lz-web-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = var.tags

}

resource "azurerm_linux_web_app" "web" {
  name                                           = "northstar-lz-web-244d"
  resource_group_name                            = var.resource_group_name
  location                                       = var.location
  service_plan_id                                = azurerm_service_plan.web.id
  https_only                                     = true
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false
  tags                                           = var.tags
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                     = true
    health_check_path             = "/"
    ip_restriction_default_action = "Deny"

    ip_restriction {
      name                      = "Allow-WAF-Subnet"
      priority                  = 100
      action                    = "Allow"
      virtual_network_subnet_id = var.waf_subnet_id
    }

    application_stack {
      docker_image_name   = "nginx"
      docker_registry_url = "https://index.docker.io"
    }
  }
}
