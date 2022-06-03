# Vpc creation
resource "azurerm_virtual_network" "generic" {
  name                = "${var.network_name}"
  address_space       = ["${var.network_address}"]
  location            = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name = azurerm_resource_group.Ciber-Terraform.name
}

# Subnet configuration
resource "azurerm_subnet" "http" {
  name                 = "${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.Ciber-Terraform.name
  virtual_network_name = azurerm_virtual_network.generic.name
  address_prefixes     = ["${var.subnet_address}"]
}
