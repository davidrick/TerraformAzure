
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

resource "azurerm_network_security_group" "appnsg" {
  name                = "app-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# resource "azurerm_subnet_network_security_group_association" "appnsglink" {
#   subnet_id                 = azurerm_subnet.subnetA.id
#   network_security_group_id = azurerm_network_security_group.appnsg.id
# }

resource "azurerm_windows_virtual_machine" "appvm" {
  count               = var.number_of_machines
  name                = "app-vm${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_A1_v2"
  admin_username      = "adminuser"
  admin_password      = "${var.vm_password}${count.index}"
  network_interface_ids = [
    azurerm_network_interface.app_interfaces[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [azurerm_network_interface.app_interfaces]
}

# resource "azurerm_managed_disk" "app-disk" {
#   name                 = "app-disk"
#   location             = var.location
#   resource_group_name  = var.resource_group_name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "1"
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "app-disk-attach" {
#   managed_disk_id    = azurerm_managed_disk.app-disk.id
#   virtual_machine_id = azurerm_windows_virtual_machine.appvm.id
#   lun                = "0"
#   caching            = "ReadWrite"
# }

