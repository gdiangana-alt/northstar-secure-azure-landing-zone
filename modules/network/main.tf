resource "azurerm_virtual_network" "northstar" {
  name                = "northstar-lz-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.20.0.0/16"]
  tags                = var.tags
}

resource "azurerm_network_security_group" "management" {
  name                = "northstar-lz-management-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "web" {
  name                = "northstar-lz-web-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "application" {
  name                = "northstar-lz-application-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "web" {
  name                            = "web"
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.northstar.name
  address_prefixes                = ["10.20.1.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "application" {
  name                            = "application"
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.northstar.name
  address_prefixes                = ["10.20.2.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "management" {
  name                            = "management"
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.northstar.name
  address_prefixes                = ["10.20.3.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "application" {
  subnet_id                 = azurerm_subnet.application.id
  network_security_group_id = azurerm_network_security_group.application.id
}

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_network_security_rule" "allow_management_to_web" {
  name                        = "Allow-Management-To-Web-HTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.20.3.0/24"
  destination_address_prefix  = "10.20.1.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.web.name
}

resource "azurerm_network_security_rule" "allow_web_to_application" {
  name                        = "Allow-Web-To-Application-HTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = "10.20.1.0/24"
  destination_address_prefix  = "10.20.2.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.application.name
}
