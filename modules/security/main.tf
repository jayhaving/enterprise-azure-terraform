resource "azurerm_resource_group" "sec_rg" {
  name     = "rg-security-${var.environment}"
  location = var.location
}

# ------------------------------------------------------------------------------
# 1. LOG ANALYTICS WORKSPACE
# ------------------------------------------------------------------------------
# We keep LAW as gathering basic logs is necessary for a security posture.
# The PerGB2018 SKU charges per ingested GB, but keeping retention to 30 days
# and not turning on Defender/Sentinel keeps costs near zero for a demo.
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-security-${var.environment}"
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30 # Reduced to 30 days to limit costs
}

# ------------------------------------------------------------------------------
# NOTE: MICROSOFT SENTINEL & DEFENDER FOR CLOUD ARE REMOVED TO PREVENT COSTS.
# In a true Enterprise scenario, these would be enabled here.
# For this portfolio piece, Azure Policy (in policies.tf) demonstrates
# continuous compliance and guardrail engineering at ZERO cost.
# ------------------------------------------------------------------------------
