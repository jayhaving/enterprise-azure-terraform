data "azurerm_subscription" "current" {}
data "azuread_client_config" "current" {}

# ------------------------------------------------------------------------------
# 1. ENTIDAD (AZURE AD) GROUPS
# ------------------------------------------------------------------------------

resource "azuread_group" "developers" {
  display_name     = "grp-developers-${var.environment}"
  security_enabled = true
}

resource "azuread_group" "security_engineers" {
  display_name     = "grp-security-engineers-${var.environment}"
  security_enabled = true
}

resource "azuread_group" "soc_analysts" {
  display_name     = "grp-soc-analysts-${var.environment}"
  security_enabled = true
}

resource "azuread_group" "platform_engineers" {
  display_name     = "grp-platform-engineers-${var.environment}"
  security_enabled = true
}

resource "azuread_group" "auditors" {
  display_name     = "grp-auditors-${var.environment}"
  security_enabled = true
}

# ------------------------------------------------------------------------------
# 2. CUSTOM RBAC ROLES
# ------------------------------------------------------------------------------

resource "azurerm_role_definition" "security_reader" {
  name        = "Custom - Security Reader (${var.environment})"
  scope       = data.azurerm_subscription.current.id
  description = "Provides read access to security and monitoring data."

  permissions {
    actions = [
      "Microsoft.Security/*",
      "Microsoft.Insights/*",
      "Microsoft.Resources/subscriptions/resourceGroups/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

resource "azurerm_role_definition" "platform_engineer" {
  name        = "Custom - Platform Engineer (${var.environment})"
  scope       = data.azurerm_subscription.current.id
  description = "Provides platform management rights."

  permissions {
    actions = [
      "Microsoft.Compute/*",
      "Microsoft.Network/*",
      "Microsoft.Storage/*"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

resource "azurerm_role_definition" "soc_analyst" {
  name        = "Custom - SOC Analyst (${var.environment})"
  scope       = data.azurerm_subscription.current.id
  description = "Provides security operational insights access."

  permissions {
    actions = [
      "Microsoft.Security/*",
      "Microsoft.Insights/*",
      "Microsoft.OperationalInsights/*"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

# ------------------------------------------------------------------------------
# 3. ROLE ASSIGNMENTS (Group-based RBAC)
# ------------------------------------------------------------------------------

resource "azurerm_role_assignment" "soc_analyst_assignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.soc_analyst.role_definition_resource_id
  principal_id       = azuread_group.soc_analysts.object_id
}

resource "azurerm_role_assignment" "platform_engineer_assignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.platform_engineer.role_definition_resource_id
  principal_id       = azuread_group.platform_engineers.object_id
}

resource "azurerm_role_assignment" "security_engineer_assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Security Admin" # Built-in role
  principal_id         = azuread_group.security_engineers.object_id
}

resource "azurerm_role_assignment" "auditor_assignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.security_reader.role_definition_resource_id
  principal_id       = azuread_group.auditors.object_id
}

# ------------------------------------------------------------------------------
# 4. BREAK GLASS / EMERGENCY ACCESS ACCOUNTS
# ------------------------------------------------------------------------------
resource "random_password" "breakglass_pwd_1" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "breakglass_pwd_2" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azuread_user" "breakglass_1" {
  user_principal_name   = "breakglass-admin-1@${var.tenant_id}"
  display_name          = "Emergency Access Account 1"
  password              = random_password.breakglass_pwd_1.result
  force_password_change = false

  # In a real environment, conditional access policies to EXCLUDE this user from MFA
  # and alert on login would be implemented. 
}

resource "azuread_user" "breakglass_2" {
  user_principal_name   = "breakglass-admin-2@${var.tenant_id}"
  display_name          = "Emergency Access Account 2"
  password              = random_password.breakglass_pwd_2.result
  force_password_change = false
}

resource "azurerm_role_assignment" "breakglass_1_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_user.breakglass_1.object_id
}

resource "azurerm_role_assignment" "breakglass_2_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_user.breakglass_2.object_id
}
