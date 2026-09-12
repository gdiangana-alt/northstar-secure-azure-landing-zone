resource "azurerm_monitor_diagnostic_setting" "application_gateway" {
  name                       = "northstar-gateway-to-soc"
  target_resource_id         = azurerm_application_gateway.northstar.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }
}
