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
  count                 = local.container_count
  name                  = "${var.azurerm_storage_container_name}${count.index}"
  storage_account_name  = var.azurerm_storage_account_name
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.storedrterraform]
}

resource "azurerm_storage_blob" "maintfblob" {
  for_each               = tomap({ sample1 = "sample1.txt", sample2 = "sample2.txt", sample3 = "sample3.txt" })
  name                   = "${var.azurerm_storage_blob_name}${each.key}"
  storage_account_name   = var.azurerm_storage_account_name
  storage_container_name = "data0"
  type                   = "Block"
  source                 = "C:\\Certification\\Terraform on Azure\\TerraformAzure\\sample-blobs\\${each.value}"
  depends_on             = [azurerm_storage_container.data]
}
