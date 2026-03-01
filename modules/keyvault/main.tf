data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "kv_rg" {
  name     = "rg-keyvault-${var.environment}"
  location = var.location
}

# ------------------------------------------------------------------------------
# 1. KEY VAULT WITH SECURITY BEST PRACTICES (Low-Cost Model)
# ------------------------------------------------------------------------------
resource "azurerm_key_vault" "kv" {
  name                        = "kv-secure-${var.environment}-${substr(uuid(), 0, 5)}"
  location                    = azurerm_resource_group.kv_rg.location
  resource_group_name         = azurerm_resource_group.kv_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  rbac_authorization_enabled  = true # Best practice: RBAC instead of Access Policies
  sku_name                    = "standard"

  # Network ACLs - Deny default
  # We establish network restrictions natively rather than paying for Private Links
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

output "key_vault_id" {
  value = azurerm_key_vault.kv.id
}
