variable "resource_group_name" {
  description = "Resource group for all alerts"
  type        = string
}

variable "tags" {
  description = "Base tags applied to all alerts"
  type        = map(string)
  default     = {}
}

variable "alert_definitions" {
  description = <<EOT
Map of alert definitions keyed by a short name.
Each object supports:
- target_resource_ids (list of strings) — multiple scopes per alert
- criteria (list of objects) — multiple metrics per alert
  - metric_namespace (string)
  - metric_name      (string)
  - aggregation      (string)
  - operator         (string)
  - threshold        (number)
  - dimensions       (optional list of objects)
    - name     (string)
    - operator (string)
    - values   (list of strings)
- description         (string, optional)
- severity            (number, optional)
- frequency           (string, optional, ISO8601 duration)
- window_size         (string, optional, ISO8601 duration)
- enabled             (bool, optional)
- tags                (map(string), optional)
EOT
  type = map(object({
    target_resource_ids = list(string)
    criteria = list(object({
      metric_namespace = string
      metric_name      = string
      aggregation      = string
      operator         = string
      threshold        = number
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })))
    }))
    description = optional(string)
    severity    = optional(number)
    frequency   = optional(string)
    window_size = optional(string)
    enabled     = optional(bool)
    tags        = optional(map(string))
  }))
}

variable "action_group_ids" {
  description = "List of Action Group resource IDs for notifications"
  type        = list(string)
  default     = []
}

variable "target_resource_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "action_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
