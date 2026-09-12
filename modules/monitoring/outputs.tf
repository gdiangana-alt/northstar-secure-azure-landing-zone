output "log_analytics_workspace_id" {
  description = "Resource ID of the NorthStar SOC Log Analytics workspace."
  value       = data.azurerm_log_analytics_workspace.soc.id
}
