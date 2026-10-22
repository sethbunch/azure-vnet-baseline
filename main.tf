terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}"
  location = var.location

}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "nsg-${var.project_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "app" {
  name                 = "snet-${var.project_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_public_ip" "nat_pip" {
  name                = "pip-nat-${var.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = var.pub_ip_sku
}

resource "azurerm_nat_gateway" "nat" {
  name                = "nat-${var.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_name            = var.nat_gateway_sku
}

resource "azurerm_nat_gateway_public_ip_association" "natpipa" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "snetnat" {
  subnet_id      = azurerm_subnet.app.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_public_ip" "lb_pip" {
  name                = "pip-lb-nat-${var.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = var.pub_ip_sku
}

resource "azurerm_lb" "lb" {
  name                = "lb-${var.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.pub_ip_sku

  frontend_ip_configuration {
    name                 = "PublicFrontend"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "app_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "ssh-running-probe"
  port                = var.backend_port
  request_path        = "/health"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "80-to-8080"
  protocol                       = "Tcp"
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = "PublicFrontend"
  backend_address_pool_ids       =  [azurerm_lb_backend_address_pool.app_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
  disable_outbound_snat          = true
}