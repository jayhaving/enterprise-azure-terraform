terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }
  }
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "The Azure Subscription ID for role definitions"
}

variable "environment" {
  type        = string
  description = "The deployment environment (dev, staging, prod)"
}
