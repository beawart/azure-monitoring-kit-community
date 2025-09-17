#############################################
# Module: baseline-alerts
# Purpose: Module for all Baseline Alerting
# Author: Taha's Azure Kit - statem8
#############################################

locals {
  # Merge defaults with overrides
  merged_alerts = {
    for alert_name, default_cfg in lookup(local.baseline_defaults, var.resource_type, {}) :
    alert_name => merge(
      default_cfg,
      try(var.alerts_overrides[alert_name], {}) # safer than lookup() here
    )
  }
}

resource "azurerm_monitor_metric_alert" "baseline" {
  for_each = {
    for name, cfg in local.merged_alerts :
    name => cfg if lookup(cfg, "enabled", true)
  }

  name                = lower("${each.key}-${basename(var.target_resource_ids[0])}-alert")
  resource_group_name = var.resource_group_name
  scopes              = var.target_resource_ids
  description         = coalesce(each.value.description, "${each.key} metric alert")
  severity            = lookup(each.value, "severity", 3)
  frequency           = lookup(each.value, "frequency", "PT5M")
  window_size         = lookup(each.value, "window_size", "PT5M")
  enabled             = lookup(each.value, "enabled", true)
  tags                = merge(var.tags, lookup(each.value, "tags", {}))

  criteria {
    metric_namespace = each.value.metric_namespace
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }

  dynamic "action" {
    for_each = var.action_group_ids
    content {
      action_group_id = action.value
    }
  }
}

