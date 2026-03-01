resource "azurerm_resource_group" "st_rg" {
  name     = "rg-storage-${var.environment}"
  location = var.location
}

# ------------------------------------------------------------------------------
# 1. SECURE STORAGE ACCOUNT (Free/Low-Cost Model)
# ------------------------------------------------------------------------------
resource "azurerm_storage_account" "sa" {
  # Storage accounts can be a few cents per month
  name                     = "stsecure${var.environment}${substr(uuid(), 0, 5)}"
  resource_group_name      = azurerm_resource_group.st_rg.name
  location                 = azurerm_resource_group.st_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Lowest cost replication

  # Security Rules - Enforced without requiring expensive Private Endpoints
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false # We restrict it, but don't deploy Private Links (saves ~$7/mo)
  shared_access_key_enabled       = false # Require RBAC (Zero Trust)
}
