data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "landing_zone" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.landing_zone.name
  location            = azurerm_resource_group.landing_zone.location
  tags                = var.tags
}

module "governance" {
  source = "./modules/governance"

  resource_group_id = azurerm_resource_group.landing_zone.id
}

module "identity" {
  source = "./modules/identity"

  resource_group_name               = azurerm_resource_group.landing_zone.name
  resource_group_id                 = azurerm_resource_group.landing_zone.id
  location                          = azurerm_resource_group.landing_zone.location
  tags                              = var.tags
  cloud_admins_group_object_id      = "53bac32e-b067-4831-9d24-8f5866d1fb23"
  security_analysts_group_object_id = "36c77f4d-3f74-4391-9877-d5fb7212f0dd"
}

module "monitoring" {
  source = "./modules/monitoring"

  workspace_name                = "NorthStar-SOC-Workspace"
  workspace_resource_group_name = "NorthStar-Azure-RG"
  subscription_id               = data.azurerm_subscription.current.subscription_id
}
