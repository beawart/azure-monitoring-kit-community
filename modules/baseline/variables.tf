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

variable "tags" {
  type    = map(string)
  default = {}
}
