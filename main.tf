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

  resource_group_name = azurerm_resource_group.landing_zone.name
  resource_group_id   = azurerm_resource_group.landing_zone.id
  location            = azurerm_resource_group.landing_zone.location
  tags                = var.tags
}

module "monitoring" {
  source = "./modules/monitoring"

  workspace_name                = "NorthStar-SOC-Workspace"
  workspace_resource_group_name = "NorthStar-Azure-RG"
  subscription_id               = data.azurerm_subscription.current.subscription_id
}
