#############################################
# Outputs for baseline-alerts
#############################################

output "merged_alerts" {
  value = local.merged_alerts
}

output "metric_alerts" {
  value = local.metric_alerts
}

output "activity_log_alerts" {
  value = local.activity_log_alerts
}

# Add more outputs as needed
