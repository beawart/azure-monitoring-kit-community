#############################################
# Variables for metric-alert
#############################################

variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "location" {
  description = "Azure region for the resource"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the resource will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resource"
  type        = map(string)
  default     = {}
}

# Add more variables as needed
