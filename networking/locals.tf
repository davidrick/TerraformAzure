locals {
  virtual_network = {
    virtual_network_name          = "app-network"
    virtual_network_address_space = "10.0.0.0/16"
    network_interface_name= "network-interface"
  }
}
