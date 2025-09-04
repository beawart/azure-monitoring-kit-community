# modules/log-analytics/main.tf

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_days
  tags                = var.tags
}

# Optional: attach solutions, policies, or role assignments here
