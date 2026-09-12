resource "azurerm_policy_definition" "require_project_tag" {
  name         = "northstar-require-project-tag"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "NorthStar - Audit missing Project tag"
  description  = "Audits resources that do not contain the required Project tag."

  metadata = jsonencode({
    category = "Governance"
  })

  policy_rule = jsonencode({
    if = {
      field  = "tags['Project']"
      exists = "false"
    }

    then = {
      effect = "audit"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "require_project_tag" {
  name                 = "northstar-audit-project-tag"
  resource_group_id    = var.resource_group_id
  policy_definition_id = azurerm_policy_definition.require_project_tag.id
  display_name         = "NorthStar - Audit missing Project tag"
  description          = "Portfolio governance control: audit required Project tags."
}
