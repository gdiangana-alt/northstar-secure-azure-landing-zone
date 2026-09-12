resource "azurerm_web_application_firewall_policy" "northstar" {
  name                = "northstar-lz-waf-policy"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  policy_settings {
    enabled = true
    mode    = "Detection"
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}
