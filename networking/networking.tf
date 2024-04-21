
resource "azurerm_virtual_network" "app_network" {
  name                = local.virtual_network.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [local.virtual_network.virtual_network_address_space]

  # subnet {
  #   name           = local.virtual_network.subnets[0].name
  #   address_prefix = local.virtual_network.subnets[0].address_prefix
  # }

  # subnet {
  #   name           = local.virtual_network.subnets[1].name
  #   address_prefix = local.virtual_network.subnets[1].address_prefix
  # }ter
}

resource "azurerm_subnet" "subnets" {
  count                = var.number_of_subnets
  name                 = "Subnet${count.index}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.virtual_network.virtual_network_name
  address_prefixes     = ["10.0.${count.index}.0/24"]
  depends_on           = [azurerm_virtual_network.app_network]
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "app_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_link" {
  count                     = var.number_of_subnets
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
  depends_on = [
    azurerm_network_security_group.app_nsg,
  azurerm_virtual_network.app_network]
}


