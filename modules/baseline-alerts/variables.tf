#############################################
# Variables for baseline-alerts
#############################################

variable "resource_group_name" {
  type = string
}

variable "target_resource_ids" {
  type = list(string)
}

variable "resource_type" {
  description = "Type of resource for baseline defaults (e.g., storage_account, key_vault)"
  type        = string
}

variable "alerts_overrides" {
  description = <<EOT
Map of alert overrides keyed by alert name.
Only specify keys you want to override from the baseline defaults.
EOT
  type = map(object({
    enabled     = optional(bool)
    threshold   = optional(number)
    severity    = optional(number)
    frequency   = optional(string)
    window_size = optional(string)
    operator    = optional(string)
    aggregation = optional(string)
    tags        = optional(map(string))
    description = optional(string)
  }))
  default = {}
}

variable "action_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "location" {
  type = string
}

