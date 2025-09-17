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
  description = "Map of alert overrides keyed by alert name"
  type = map(object({
    enabled          = optional(bool)
    threshold        = optional(number)
    severity         = optional(number)
    frequency        = optional(string)
    window_size      = optional(string)
    operator         = optional(string)
    aggregation      = optional(string)
    tags             = optional(map(string))
    description      = optional(string)
    category         = optional(string) # For activity log
    operation        = optional(string) # For activity log
    metric_namespace = optional(string)
    metric_name      = optional(string)
  }))
  default = {}

  # 1️⃣ Window size restriction for UsedCapacity
  validation {
    condition = alltrue([
      for k, v in var.alerts_overrides :
      (
        lower(k) != "used_capacity"
        || v.window_size == null
        || contains(["PT1H", "PT6H", "PT12H", "P1D"], v.window_size)
      )
    ])
    error_message = "For 'UsedCapacity' alerts, window_size must be one of: PT1H, PT6H, PT12H, P1D."
  }

  # 2️⃣ Severity must be 0–4
  validation {
    condition = alltrue([
      for _, v in var.alerts_overrides :
      (
        v.severity == null || contains([0, 1, 2, 3, 4], v.severity)
      )
    ])
    error_message = "Severity must be an integer between 0 and 4."
  }

  # 3️⃣ Frequency must be ISO 8601 duration
  validation {
    condition = alltrue([
      for _, v in var.alerts_overrides :
      (
        v.frequency == null || can(regex("^PT[0-9]+[MH]$", v.frequency))
      )
    ])
    error_message = "Frequency must be an ISO 8601 duration like PT5M, PT1H, etc."
  }

  # 4️⃣ Metric namespace validation (dynamic from defaults)
  validation {
    condition = alltrue([
      for _, v in var.alerts_overrides :
      (
        v.metric_namespace == null
        || length(local.allowed_metric_namespaces) == 0
        || contains(local.allowed_metric_namespaces, v.metric_namespace)
      )
    ])
    error_message = "metric_namespace must be one of the allowed namespaces for this resource_type."
  }

  # 5️⃣ Metric name validation (dynamic from defaults)
  validation {
    condition = alltrue([
      for _, v in var.alerts_overrides :
      (
        v.metric_name == null
        || length(local.allowed_metric_names) == 0
        || contains(local.allowed_metric_names, v.metric_name)
      )
    ])
    error_message = "metric_name must be one of the allowed metrics for this resource_type."
  }

  # 6️⃣ Activity Log category validation (dynamic from defaults)
  validation {
    condition = alltrue([
      for _, v in var.alerts_overrides :
      (
        v.category == null
        || length(local.allowed_activity_categories) == 0
        || contains(local.allowed_activity_categories, v.category)
      )
    ])
    error_message = "Activity Log category must be one of the allowed categories for this resource_type."
  }

  # 7️⃣ Activity Log operation validation (dynamic from defaults)
  validation {
    condition = alltrue([
      for _, v in var.alerts_overrides :
      (
        v.operation == null
        || length(local.allowed_activity_operations) == 0
        || contains(local.allowed_activity_operations, v.operation)
      )
    ])
    error_message = "Activity Log operation must be one of the allowed operations for this resource_type."
  }
}


variable "action_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}


