output "rg_name" {
  description = "Resource group everything lives in."
  value       = azurerm_resource_group.rg.name
}

output "subnet_id" {
  description = "App subnet ID. This is what the Phase 4 VMSS NICs plug into."
  value       = azurerm_subnet.app.id
}

output "nat_gateway_ip" {
  description = "The one static IP all outbound traffic leaves from. Allowlist this on anything downstream."
  value       = azurerm_public_ip.nat_pip.ip_address
}

output "lb_ip" {
  description = "Public IP of the LB frontend. Point DNS here."
  value       = azurerm_public_ip.lb_pip.ip_address
}
