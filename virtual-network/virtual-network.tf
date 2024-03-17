
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
  # }
}

resource "azurerm_subnet" "subnetA" {
  name                 = local.virtual_network.subnets[0].name
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.virtual_network.virtual_network_name
  address_prefixes     = [local.virtual_network.subnets[0].address_prefix]
  depends_on           = [azurerm_virtual_network.app_network]
}

resource "azurerm_subnet" "subnetB" {
  name                 = local.virtual_network.subnets[1].name
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.virtual_network.virtual_network_name
  address_prefixes     = [local.virtual_network.subnets[1].address_prefix]
  depends_on           = [azurerm_virtual_network.app_network]
}

resource "azurerm_network_interface" "app_interface_subnetA" {
  name                = "${local.virtual_network.network_interface_name}_subnetA"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_ip_subnetA.id
  }
}

resource "azurerm_network_interface" "app_interface_subnetB" {
  name                = "${local.virtual_network.network_interface_name}_subnetB"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetB.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_ip_subnetB.id
  }
}

resource "azurerm_public_ip" "app_ip_subnetA" {
  name                = "app-ip_subnetA"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "app_ip_subnetB" {
  name                = "app-ip_subnetB"
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

resource "azurerm_subnet_network_security_group_association" "appnsglink" {
  subnet_id                 = azurerm_subnet.subnetA.id
  network_security_group_id = azurerm_network_security_group.appnsg.id
}

resource "azurerm_windows_virtual_machine" "appvm" {
  name                = "app-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_A1_v2"
  admin_username      = "adminuser"
  admin_password      = "**add password**"
  network_interface_ids = [
    azurerm_network_interface.app_interface_subnetA.id,
    azurerm_network_interface.app_interface_subnetB.id
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
}


