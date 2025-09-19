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

# Baseline-alerts

# -------------------------
# Pro-Only Modules
# -------------------------

# Dynamic Metric Alerting
# Alert rule processing
# Azure monitor - Prod ready - Dashboard and Workbooks
# DCR
