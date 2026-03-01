variable "location" {
  type        = string
  description = "Azure Region for Security Resources"
}

variable "environment" {
  type        = string
  description = "Execution Environment (dev, staging, prod)"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain logs in Log Analytics Workspace"
  default     = 90
}
