locals {
  baseline_defaults = {
    # Virtual Machine baseline alerts
    virtual_machine = {
      cpu_utilization_high = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Compute/virtualMachines"
        metric_name      = "Percentage CPU"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 90
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT15M"
        enabled          = true
      }
      cpu_utilization_low = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Compute/virtualMachines"
        metric_name      = "Percentage CPU"
        aggregation      = "Average"
        operator         = "LessThan"
        threshold        = 5
        severity         = 3
        frequency        = "PT5M"
        window_size      = "PT15M"
        enabled          = true
      }
      vm_availability = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Compute/virtualMachines"
        metric_name      = "Availability"
        aggregation      = "Average"
        operator         = "LessThan"
        threshold        = 100
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT5M"
        enabled          = true
      }
    }

    # App Service baseline alerts
    app_service = {
      http_5xx_errors = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Web/sites"
        metric_name      = "Http5xx"
        aggregation      = "Total"
        operator         = "GreaterThan"
        threshold        = 10
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT5M"
        enabled          = true
      }
      cpu_high = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Web/sites"
        metric_name      = "CpuPercentage"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 90
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT15M"
        enabled          = true
      }
      memory_high = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Web/sites"
        metric_name      = "MemoryPercentage"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 90
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT15M"
        enabled          = true
      }
    }

    # Storage Account baseline alerts
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
    }

    # SQL Database baseline alerts
    sql_database = {
      dtu_consumption_high = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Sql/servers/databases"
        metric_name      = "dtu_consumption_percent"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 90
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT15M"
        enabled          = true
      }
      storage_percent_high = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Sql/servers/databases"
        metric_name      = "storage_percent"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 90
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT15M"
        enabled          = true
      }
      deadlocks_detected = {
        alert_type       = "metric"
        metric_namespace = "Microsoft.Sql/servers/databases"
        metric_name      = "deadlock"
        aggregation      = "Total"
        operator         = "GreaterThan"
        threshold        = 0
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT5M"
        enabled          = true
      }
    }
  }

  # Allowed values derived from defaults
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
    cfg.operation_name if lookup(cfg, "alert_type", "") == "activity_log"
  ])
}
