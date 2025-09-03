output "log_analytics_workspace_id" {
  value       = module.log_analytics.workspace_id
  description = "ID of the Log Analytics workspace"
}

output "grafana_url" {
  value       = try(module.grafana_prometheus[0].grafana_url, null)
  description = "Grafana endpoint (Pro only)"
}
