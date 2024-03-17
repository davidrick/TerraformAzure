resource "azurerm_storage_account" "storedrterraform" {
  name                     = var.azurerm_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    environment = "development"
  }
}

resource "azurerm_storage_container" "data" {
  name                  = var.azurerm_storage_container_name
  storage_account_name  = var.azurerm_storage_account_name
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.storedrterraform]
}

resource "azurerm_storage_blob" "maintfblob" {
  name                   = var.azurerm_storage_blob_name
  storage_account_name   = var.azurerm_storage_account_name
  storage_container_name = "data"
  type                   = "Block"
  source                 = "main.tf"
  depends_on             = [azurerm_storage_container.data]
}
