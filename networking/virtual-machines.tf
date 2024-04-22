
resource "azurerm_network_interface" "app_interfaces" {
  count               = var.number_of_machines
  name                = "appinterface${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_ips[count.index].id
  }
  depends_on = [azurerm_public_ip.app_ips]
}

resource "azurerm_public_ip" "app_ips" {
  count               = var.number_of_machines
  name                = "app${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}
