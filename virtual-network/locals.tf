locals {
  virtual_network = {
    virtual_network_name          = "app-network"
    virtual_network_address_space = "10.0.0.0/16"
    subnets = [
      {
        name           = "subnetA",
        address_prefix = "10.0.0.0/24"
      },
      {
        name           = "subnetB",
        address_prefix = "10.0.1.0/24"
      }
    ],
    network_interface_name= "network-interface"
  }
}
