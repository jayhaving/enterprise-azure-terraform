output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub.id
  description = "The ID of the Hub Virtual Network"
}

output "spoke_vnet_id" {
  value       = azurerm_virtual_network.spoke.id
  description = "The ID of the Spoke Virtual Network"
}

output "spoke_app_subnet_id" {
  value       = azurerm_subnet.app.id
  description = "The ID of the Spoke App Subnet"
}

output "spoke_db_subnet_id" {
  value       = azurerm_subnet.db.id
  description = "The ID of the Spoke Database Subnet"
}
