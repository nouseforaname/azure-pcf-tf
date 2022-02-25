resource "azurerm_storage_account" "tas" {
  name                     = "bosh${lower(random_string.suffix.result)}"
  resource_group_name      = azurerm_resource_group.tas.name
  location                 = azurerm_resource_group.tas.location
  account_tier             = "standard"
  account_replication_type = "lrs"

  tags = {
    environment = "${var.env_name}"
  }
}
resource "azurerm_storage_container" "opsmanager" {
  name                  = "opsmanager"
  storage_account_name  = azurerm_storage_account.tas.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "bosh" {
  name                  = "bosh"
  storage_account_name  = azurerm_storage_account.tas.name
  container_access_type = "private"
}
resource "azurerm_storage_container" "stemcell" {
  name                  = "stemcell"
  storage_account_name  = azurerm_storage_account.tas.name
  container_access_type = "private"
}
resource "azurerm_storage_account" "deployment" {
  count = 5
  name                     = "depstore${lower(random_string.suffix.result)}${count.index}"
  resource_group_name      = azurerm_resource_group.tas.name
  location                 = azurerm_resource_group.tas.location
  account_tier             = "standard"
  account_replication_type = "lrs"

  tags = {
    environment = "${var.env_name}"
  }
}
