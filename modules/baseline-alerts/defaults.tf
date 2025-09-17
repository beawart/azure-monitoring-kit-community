locals {
  baseline_defaults = {
    storage_account = {
      availability = {
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

    key_vault = {
      service_latency = {
        metric_namespace = "Microsoft.KeyVault/vaults"
        metric_name      = "ServiceApiLatency"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 500
        severity         = 2
        frequency        = "PT5M"
        window_size      = "PT5M"
        enabled          = true
      }
    }
  }
}
