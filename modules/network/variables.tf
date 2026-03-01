variable "location" {
  type        = string
  description = "Azure Region"
}

variable "environment" {
  type        = string
  description = "Environment Name (dev, staging, prod)"
}

variable "hub_vnet_address_space" {
  type        = list(string)
  description = "Address space for Hub VNet"
  default     = ["10.0.0.0/16"]
}

variable "spoke_vnet_address_space" {
  type        = list(string)
  description = "Address space for Spoke VNet"
  default     = ["10.1.0.0/16"]
}
