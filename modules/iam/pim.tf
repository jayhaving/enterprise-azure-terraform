# ------------------------------------------------------------------------------
# 5. PRIVILEGED IDENTITY MANAGEMENT (PIM) - JIT ACCESS
# ------------------------------------------------------------------------------

# Fetch the built-in role definitions for PIM eligibility
data "azurerm_role_definition" "subscription_contributor" {
  name = "Contributor"
}
data "azurerm_role_definition" "security_admin" {
  name = "Security Admin"
}
data "azurerm_role_definition" "network_contributor" {
  name = "Network Contributor"
}

# NOTE: The azurerm provider supports azurerm_role_management_policy and assignment schedules, 
# but PIM for Azure AD groups is typically done via azuread_privileged_access_group_eligibility_schedule_request.
# However, mapping Azure Resource roles (like Contributor) using PIM requires the `azapi` provider 
# or explicit Azure AD features. For this architecture, we demonstrate the Azure resource role 
# eligibility schedule request configuration available natively.

# Assuming the Principal (e.g., Platform Engineers Group) requires PIM for Contributor on the Subscription
resource "azurerm_pim_eligible_role_assignment" "platform_engineer_contributor" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.subscription_contributor.id}"
  principal_id       = azuread_group.platform_engineers.object_id

  schedule {
    start_date_time = "2024-01-01T00:00:00Z"
    expiration {
      duration_days = 365
    }
  }

  justification = "Required for platform engineering tasks via JIT"
}

resource "azurerm_pim_eligible_role_assignment" "security_engineer_admin" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.security_admin.id}"
  principal_id       = azuread_group.security_engineers.object_id

  schedule {
    start_date_time = "2024-01-01T00:00:00Z"
    expiration {
      duration_days = 365
    }
  }

  justification = "Required for security administration tasks via JIT"
}

resource "azurerm_pim_eligible_role_assignment" "platform_engineer_network" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.network_contributor.id}"
  principal_id       = azuread_group.platform_engineers.object_id

  schedule {
    start_date_time = "2024-01-01T00:00:00Z"
    expiration {
      duration_days = 365
    }
  }

  justification = "Required for network modifications via JIT"
}

# The PIM policy itself (requiring MFA, 1 hour duration, approval workflow) 
# is configured via the azapi provider or `azurerm_role_management_policy` (in preview or via portal defaults).
# For compliance, we assume the default PIM policy on the tenant requires MFA & approval.
