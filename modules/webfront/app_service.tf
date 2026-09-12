resource "azurerm_service_plan" "web" {
  name                = "northstar-lz-web-plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "web" {
  name                = "northstar-lz-web-244d"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.web.id
  https_only          = true
  tags                = var.tags

  site_config {
    always_on = true

    application_stack {
      docker_image_name   = "nginx"
      docker_registry_url = "https://index.docker.io"
    }
  }
}
