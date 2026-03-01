data "azurerm_subscription" "current_policy" {}

# ------------------------------------------------------------------------------
# 4. AZURE POLICY GUARDRAILS 
# ------------------------------------------------------------------------------

# Define a custom policy to Deny Storage Accounts without Secure Transfer
resource "azurerm_policy_definition" "deny_unencrypted_storage" {
  name         = "deny-unencrypted-storage-${var.environment}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Unencrypted/HTTP Storage Accounts"
  description  = "This policy denies the creation of storage accounts if secure transfer is disabled or bypasses Azure networks."

  metadata = <<METADATA
    {
    "category": "Storage"
    }
METADATA

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Storage/storageAccounts"
      },
      {
        "field": "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
        "equals": "false"
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}

resource "azurerm_subscription_policy_assignment" "enforce_storage_https" {
  name                 = "enforce-storage-https"
  subscription_id      = data.azurerm_subscription.current_policy.id
  policy_definition_id = azurerm_policy_definition.deny_unencrypted_storage.id
  description          = "Enforces HTTPS on all Storage Accounts"
  display_name         = "Enforce HTTPS on Storage Accounts"
}

# Let's use Azure Built-In Policies for the rest to demonstrate using built-ins (Best Practice)
# Built-in Policy IDs:
# Storage Account Public Network Access should be disabled (Deny)
# ID: /providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693
resource "azurerm_subscription_policy_assignment" "deny_storage_public" {
  name                 = "deny-storage-public"
  subscription_id      = data.azurerm_subscription.current_policy.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693"
  display_name         = "Deny Public Access to Storage Accounts"

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}

# Require Tag on Resources
# ID: /providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99
resource "azurerm_subscription_policy_assignment" "require_env_tag" {
  name                 = "require-env-tag"
  subscription_id      = data.azurerm_subscription.current_policy.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  display_name         = "Require 'Environment' Tag"

  parameters = <<PARAMETERS
{
  "tagName": {
    "value": "Environment"
  }
}
PARAMETERS
}

# Key Vault should have purge protection enabled
# ID: /providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53
resource "azurerm_subscription_policy_assignment" "kv_purge_protection" {
  name                 = "kv-purge-protection"
  subscription_id      = data.azurerm_subscription.current_policy.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53"
  display_name         = "Key Vault Purge Protection Enabled"

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Deny"
  }
}
PARAMETERS
}
