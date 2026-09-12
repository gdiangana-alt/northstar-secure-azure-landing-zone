data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "northstar" {
  name                          = "northstarlzkv244d"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  purge_protection_enabled      = false
  soft_delete_retention_days    = 7
  public_network_access_enabled = true
  tags                          = var.tags

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

resource "azurerm_role_assignment" "web_app_key_vault_secrets_user" {
  scope                            = azurerm_key_vault.northstar.id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_linux_web_app.web.identity[0].principal_id
  skip_service_principal_aad_check = true
}
