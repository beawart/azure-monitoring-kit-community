locals {
  expanded_alerts = {
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

    # 2️⃣ Percent Success
    percent_success = {
      scope_id    = var.target_resource_id
      description = "Storage request success rate dropped"
      severity    = 2
      criteria = [
        {
          metric_namespace = "Microsoft.Storage/storageAccounts"
          metric_name      = "PercentSuccess"
          aggregation      = "Average"
          operator         = "LessThan"
          threshold        = 100
        }
      ]
    }

    # 3️⃣ Network Rule Change (Activity Log)
    network_rule_change = {
      scope_id    = var.target_resource_id
      description = "Storage account network rules updated"
      severity    = 2
      criteria = [
        {
          metric_namespace = "microsoft.insights/activitylogs"
          metric_name      = "StorageAccountNetworkRuleSetUpdated"
          aggregation      = "Count"
          operator         = "GreaterThan"
          threshold        = 0
        }
      ]
    }

    # 4️⃣ Key Regeneration (Activity Log)
    key_regeneration = {
      scope_id    = var.target_resource_id
      description = "Storage account access key regenerated"
      severity    = 2
      criteria = [
        {
          metric_namespace = "microsoft.insights/activitylogs"
          metric_name      = "RegenerateKey"
          aggregation      = "Count"
          operator         = "GreaterThan"
          threshold        = 0
        }
      ]
    }
  }
}
