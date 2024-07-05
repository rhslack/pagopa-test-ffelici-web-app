# APP VNet
resource "azurerm_virtual_network" "vnet-app" {
  name                = "pagopa-tech-test-network-fe"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.254.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.254.2.0/24"]
}

resource "azurerm_subnet" "database" {
  name                 = "database"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = ["10.254.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# APPGW VNet
resource "azurerm_virtual_network" "vnet-hub" {
  name                = "pagopa-tech-test-network-gw"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.255.0.0/16"]
}

resource "azurerm_subnet" "application_gateway" {
  name                 = "application_gateway"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.255.1.0/24"]
}

# Peering
resource "azurerm_virtual_network_peering" "hub-spoke" {
  name                      = "peerhubtospoke"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet-app.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-hub.id
}

resource "azurerm_virtual_network_peering" "spoke-hub" {
  name                      = "peerspoketohub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet-hub.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-app.id
}