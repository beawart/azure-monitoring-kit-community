resource "azurerm_monitor_metric_alert" "baseline" {
  for_each = local.expanded_alerts

  # Auto-generate name: <metric(s)>-<resourceName>-alert
  name = lower(
    replace(
      "${join("-", [for c in each.value.criteria : c.metric_name])}-${basename(each.value.scope_id)}-alert",
      " ",
      "-"
    )
  )

  resource_group_name = var.resource_group_name
  scopes              = [each.value.scope_id]
  description         = coalesce(each.value.description, "Baseline metric alert")
  severity            = coalesce(each.value.severity, 3)
  frequency           = coalesce(each.value.frequency, "PT5M")
  window_size         = coalesce(each.value.window_size, "PT5M")
  enabled             = coalesce(each.value.enabled, true)
  tags                = merge(var.tags, lookup(each.value, "tags", {}))

  dynamic "criteria" {
    for_each = each.value.criteria
    content {
      metric_namespace = criteria.value.metric_namespace
      metric_name      = criteria.value.metric_name
      aggregation      = criteria.value.aggregation
      operator         = criteria.value.operator
      threshold        = criteria.value.threshold

      dynamic "dimension" {
        for_each = lookup(criteria.value, "dimensions", [])
        content {
          name     = dimension.value.name
          operator = dimension.value.operator
          values   = dimension.value.values
        }
      }
    }
  }

  # Attach one or more Action Groups
  dynamic "action" {
    for_each = var.action_group_ids
    content {
      action_group_id = action.value
    }
  }
}

