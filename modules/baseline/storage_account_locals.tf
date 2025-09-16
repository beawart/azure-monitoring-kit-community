locals {
  st_alerts = {
    # 1️⃣ Availability
    availability = {
      scope_id    = var.target_resource_id
      description = "Storage service availability below 100%"
      severity    = 2
      criteria = [
        {
          metric_namespace = "Microsoft.Storage/storageAccounts"
          metric_name      = "Availability"
          aggregation      = "Average"
          operator         = "LessThan"
          threshold        = 100
        }
      ]
    }

    # 2️⃣ UsedCapacity
    UsedCapacity = {
      scope_id    = var.target_resource_id
      description = "UsedCapacity - Metric Alert"
      severity    = 2
      criteria = [
        {
          metric_namespace = "Microsoft.Storage/storageAccounts"
          metric_name      = "UsedCapacity"
          aggregation      = "Average"
          operator         = "GreaterThan"
          threshold        = 5e+14
          frequency        = PT6H
        }
      ]
    }
  }
}
