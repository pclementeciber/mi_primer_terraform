resource "azurerm_resource_group" "Ciber-Terraform" {
  name     = "${var.resource_name}"
  location = "${var.resource_location}"
}
