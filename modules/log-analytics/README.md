# Log Analytics Module

This module deploys an Azure Log Analytics workspace with configurable retention, SKU, and tags.

## Usage

```hcl
module "log_analytics" {
  source              = "./modules/log-analytics"
  workspace_name      = "ent-monitoring-law"
  location            = "australiaeast"
  resource_group_name = "rg-monitoring"
  retention_days      = 60
  tags = {
    environment = "prod"
    owner       = "platform-team"
  }
}
```
