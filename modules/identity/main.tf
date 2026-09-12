resource "azurerm_user_assigned_identity" "landing_zone" {
  name                = "northstar-lz-automation-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "reader" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.landing_zone.principal_id
}


resource "azurerm_role_assignment" "cloud_admins_contributor" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = var.cloud_admins_group_object_id
}

resource "azurerm_role_assignment" "security_analysts_reader" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = var.security_analysts_group_object_id
}
