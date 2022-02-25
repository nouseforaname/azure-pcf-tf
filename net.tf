provider "azurerm" {
  features {}
  
}

resource "azurerm_resource_group" "tas" {
  name     = "${var.rg_name}"
  location = var.region
}


module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.tas.name
  address_spaces      = [var.net.cidr]
  subnet_prefixes     = [
    for k,v in var.net.subnets: v.cidr
  ]
  subnet_names        = [
    for k,v in var.net.subnets: k
  ]

  subnet_service_endpoints = {}

  tags = {
    environment = var.env_name 
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.tas]
}

module "network-security-group-tas" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.tas.name
  security_group_name   = "pcf-nsg"
  source_address_prefix = [var.net.cidr]
  predefined_rules = [ ]

  custom_rules = [
    for k, v in var.net.nsgs.pcf-nsg.rules:
      {
        name                   = k
        priority               = v.prio
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = v.proto
        source_port_range      = "*"
        destination_port_range = v.dport_range
        source_address_prefix  = var.net.cidr
        description            = k
      }
    ]

  tags = {
    environment = "${var.env_name}"
    costcenter  = "${var.costcenter_tag}"
  }

  depends_on = [azurerm_resource_group.tas]
}

module "network-security-group-opsmgr" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.tas.name
  security_group_name   = "opsmgr-nsg"
  source_address_prefix = [var.net.cidr]
  predefined_rules = []

  custom_rules = [
    for k, v in var.net.nsgs.opsmgr-nsg.rules:
      {
        name                   = k
        priority               = v.prio
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = v.proto
        source_port_range      = "*"
        destination_port_range = v.dport_range
        source_address_prefix  = var.net.cidr
        description            = k
      }
  ]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.tas]
}
