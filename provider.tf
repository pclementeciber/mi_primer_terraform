provider "azurerm" {
  tenant_id       = "${var.tenant}"
  subscription_id = "${var.subscription}"
  client_id       = "${var.client}"
  client_secret   = "${var.client_password}"
  features {}
}