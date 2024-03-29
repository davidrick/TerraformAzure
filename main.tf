resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location
}


# module "blob-storage_module" {
#   source                         = "./blob-storage"
#   resource_group_name            = local.resource_group_name
#   location                       = local.location
#   azurerm_storage_account_name   = "storedrterraform"
#   azurerm_storage_container_name = "data"
#   azurerm_storage_blob_name      = "maintfblob"
#   depends_on                     = [azurerm_resource_group.appgrp]
# }

module "virtual-network" {
  source              = "./virtual-network"
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.location
}

