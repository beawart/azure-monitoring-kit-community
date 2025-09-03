terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

# -------------------------
# Core / Community Modules
# -------------------------

module "log_analytics" {
  source              = "./modules/log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_days      = var.log_retention_days
  tags                = var.tags
}

module "azure_monitor_agent" {
  source              = "./modules/azure-monitor-agent"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = module.log_analytics.workspace_id
  tags                = var.tags
}

module "application_insights" {
  source              = "./modules/application-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

module "baseline_alerts" {
  source              = "./modules/baseline-alerts"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# -------------------------
# Pro-Only Modules
# -------------------------

module "grafana_prometheus" {
  count  = var.enable_pro_features ? 1 : 0
  source = "../azure-monitoring-kit-pro/modules/grafana-prometheus"
  # or use a Git URL if you grant access:
  # source = "git::https://github.com/your-org/azure-monitoring-kit-pro.git//modules/grafana-prometheus"
}
