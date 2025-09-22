#############################################
# Module: Storage Account Baseline-alerts
# Purpose: Module for all Storage Account Baseline Alerting
# Author: Taha's Azure Kit - statem8
#############################################

# Clean overrides (remove nulls)
locals {
  clean_overrides = {
    for k, v in var.alerts_overrides :
    k => { for kk, vv in v : kk => vv if vv != null }
  }

  merged_alerts = {
    for alert_name, default_cfg in lookup(local.baseline_defaults, var.resource_type, {}) :
    alert_name => merge(
      default_cfg,
      lookup(local.clean_overrides, alert_name, {})
    )
  }

  metric_alerts = {
    for name, cfg in local.merged_alerts :
    name => cfg
    if cfg.alert_type == "metric" && coalesce(lookup(cfg, "enabled", true), true)
  }

  activity_log_alerts = {
    for name, cfg in local.merged_alerts :
    name => cfg
    if cfg.alert_type == "activity_log" && coalesce(lookup(cfg, "enabled", true), true)
  }
}

# -------------------
# Metric Alerts
# -------------------
resource "azurerm_monitor_metric_alert" "st-baseline" {
  for_each = local.metric_alerts

  name                = lower("${each.key}-${basename(var.target_resource_ids[0])}-alert")
  resource_group_name = var.resource_group_name
  scopes              = var.target_resource_ids
  description         = coalesce(lookup(each.value, "description", null), "${each.key} metric alert")
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

  # Dynamic validations
  lifecycle {
    precondition {
      condition     = contains(local.allowed_metric_namespaces, each.value.metric_namespace)
      error_message = "Invalid metric_namespace for ${each.key}."
    }
    precondition {
      condition     = contains(local.allowed_metric_names, each.value.metric_name)
      error_message = "Invalid metric_name for ${each.key}."
    }
  }
}

# -------------------
# Activity Log Alerts
# -------------------
resource "azurerm_monitor_activity_log_alert" "st-baseline" {
  for_each            = local.activity_log_alerts
  name                = lower("${each.key}-${basename(var.target_resource_ids[0])}-alert")
  resource_group_name = var.resource_group_name
  location            = "global" # Required fixed value
  scopes              = var.target_resource_ids
  description         = coalesce(lookup(each.value, "description", null), "${each.key} activity log alert")
  enabled             = lookup(each.value, "enabled", true)
  tags                = merge(var.tags, lookup(each.value, "tags", {}))

  criteria {
    category       = each.value.category
    operation_name = each.value.operation_name
  }

  dynamic "action" {
    for_each = var.action_group_ids
    content {
      action_group_id = action.value
    }
  }

  # Dynamic validations
  lifecycle {
    precondition {
      condition     = contains(local.allowed_activity_categories, each.value.category)
      error_message = "Invalid category for ${each.key}."
    }
    precondition {
      condition     = contains(local.allowed_activity_operations, each.value.operation)
      error_message = "Invalid operation for ${each.key}."
    }
  }
}
