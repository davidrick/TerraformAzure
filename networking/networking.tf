
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
  count= var.number_of_subnets
  name                 = local.virtual_network.subnets[count.index].name
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.virtual_network.virtual_network_name
  address_prefixes     = [local.virtual_network.subnets[count.index].address_prefix]
  depends_on           = [azurerm_virtual_network.app_network]
}
