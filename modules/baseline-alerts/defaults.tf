locals {
  baseline_defaults = {
    storage_account = {
      availability = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Storage/storageAccounts"
        metric_name      = "Availability"
        aggregation      = "Average"
        operator         = "LessThan"
        threshold        = 100
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT5M"
        enabled          = true
      }
      used_capacity = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Storage/storageAccounts"
        metric_name      = "UsedCapacity"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 5e+14
        severity         = 2
        frequency        = "PT1H"
        window_size      = "PT6H"
        enabled          = true
      }
      network_rule_change = {
        alert_type = "activity_log"
        category   = "Administrative"
        operation  = "Microsoft.Storage/storageAccounts/networkRuleSets/write"
        severity   = 2
        enabled    = true
      }
    }
  }

  # Derived allowed values for the selected resource_type
  allowed_metric_namespaces = distinct([
    for _, cfg in lookup(local.baseline_defaults, var.resource_type, {}) :
    cfg.metric_namespace if lookup(cfg, "alert_type", "") == "metric"
  ])

  allowed_metric_names = distinct([
    for _, cfg in lookup(local.baseline_defaults, var.resource_type, {}) :
    cfg.metric_name if lookup(cfg, "alert_type", "") == "metric"
  ])

  allowed_activity_categories = distinct([
    for _, cfg in lookup(local.baseline_defaults, var.resource_type, {}) :
    cfg.category if lookup(cfg, "alert_type", "") == "activity_log"
  ])

  allowed_activity_operations = distinct([
    for _, cfg in lookup(local.baseline_defaults, var.resource_type, {}) :
    cfg.operation if lookup(cfg, "alert_type", "") == "activity_log"
  ])
}
