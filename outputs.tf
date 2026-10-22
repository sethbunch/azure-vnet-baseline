output "rg_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.rg.name
}

output "subnet_id" {
  description = "The resource ID of the application subnet."
  value       = azurerm_subnet.app.id
}

output "nat_gateway_ip" {
  description = "The ip address of the declared egress ip."
  value       = azurerm_public_ip.nat_pip.ip_address
}


output "lb_ip" {
  description = "IP of the Load balancer."
  value       = azurerm_public_ip.lb_pip.ip_address
}