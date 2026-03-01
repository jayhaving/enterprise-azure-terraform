variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_vault_id" {
  type        = string
  description = "ID of Key Vault to grant the VM's managed identity access to"
}
