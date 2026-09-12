data "azurerm_log_analytics_workspace" "soc" {
  name                = var.workspace_name
  resource_group_name = var.workspace_resource_group_name
}

resource "azurerm_monitor_diagnostic_setting" "subscription_activity" {
  name                       = "NorthStar-Activity-to-Sentinel"
  target_resource_id         = "/subscriptions/${var.subscription_id}"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.soc.id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "ServiceHealth"
  }

  enabled_log {
    category = "Alert"
  }

  enabled_log {
    category = "Recommendation"
  }

  enabled_log {
    category = "Policy"
  }

  enabled_log {
    category = "Autoscale"
  }

  enabled_log {
    category = "ResourceHealth"
  }
}
resource "azurerm_sentinel_alert_rule_scheduled" "failed_control_plane_operation" {
  name                       = "0b6f52c1-4948-4c30-8191-3cbffe47825a"
  log_analytics_workspace_id = "/subscriptions/244d087a-d706-44aa-8b72-36f3f481b025/resourceGroups/northstar-azure-rg/providers/Microsoft.OperationalInsights/workspaces/northstar-soc-workspace"
  display_name               = "NorthStar - Failed Azure Control Plane Operation"
  description                = "Detects failed Azure control-plane operations targeting the NorthStar environment. This rule supports monitoring for unsuccessful administrative changes that may indicate misconfiguration or suspicious management activity."
  severity                   = "Medium"
  enabled                    = true

  query = trimspace(<<-KQL
    AzureActivity
    | where ResourceGroup =~ "NORTHSTAR-AZURE-RG"
    | where ActivityStatusValue =~ "Failure"
    | project TimeGenerated, OperationNameValue, ActivityStatusValue, ResourceGroup
  KQL
  )

  query_frequency      = "PT5M"
  query_period         = "PT5M"
  trigger_operator     = "GreaterThan"
  trigger_threshold    = 0
  suppression_enabled  = false
  suppression_duration = "PT5H"

  custom_details = {}
  tactics        = []
  techniques     = []

  event_grouping {
    aggregation_method = "AlertPerResult"
  }

  incident {
    create_incident_enabled = true

    grouping {
      enabled                 = false
      entity_matching_method  = "AllEntities"
      lookback_duration       = "PT5H"
      reopen_closed_incidents = false
      by_alert_details        = []
      by_custom_details       = []
      by_entities             = []
    }
  }
}
