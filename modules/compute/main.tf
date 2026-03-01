resource "azurerm_resource_group" "comp_rg" {
  name     = "rg-compute-${var.environment}"
  location = var.location
}

# ------------------------------------------------------------------------------
# 1. NETWORK INTERFACE (No Public IP)
# ------------------------------------------------------------------------------
resource "azurerm_network_interface" "nic" {
  name                = "nic-vm-${var.environment}"
  location            = azurerm_resource_group.comp_rg.location
  resource_group_name = azurerm_resource_group.comp_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    # Notice: No public_ip_address_id is specified.
  }
}

# ------------------------------------------------------------------------------
# 2. VIRTUAL MACHINE WITH MANAGED IDENTITY (Free Tier Size)
# ------------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-app-${var.environment}"
  resource_group_name = azurerm_resource_group.comp_rg.name
  location            = azurerm_resource_group.comp_rg.location

  # Changed from B2s to B1s to qualify for Azure free tier
  size           = "Standard_B1s"
  admin_username = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub") # Requires SSH key on runner
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # THIS IS THE CRITICAL SECURITY REQUIREMENT: No Secrets
  identity {
    type = "SystemAssigned"
  }
}

# ------------------------------------------------------------------------------
# 3. RBAC: GRANT VM MANAGED IDENTITY ACCESS TO KEY VAULT
# ------------------------------------------------------------------------------
resource "azurerm_role_assignment" "vm_kv_secrets_user" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}
