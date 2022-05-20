resource "azurerm_resource_group" "Ciber-Terraform" {
  name     = "ciber-terraform"
  location = "North Europe"
}
# Vpc creation
resource "azurerm_virtual_network" "generic" {
  name                = "network-terraform"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name = azurerm_resource_group.Ciber-Terraform.name
}

# Subnet configuration
resource "azurerm_subnet" "http" {
  name                 = "subnet-http-tf"
  resource_group_name  = azurerm_resource_group.Ciber-Terraform.name
  virtual_network_name = azurerm_virtual_network.generic.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "BBDD" {
  name                 = "subnet-BBDD-tf"
  resource_group_name  = azurerm_resource_group.Ciber-Terraform.name
  virtual_network_name = azurerm_virtual_network.generic.name
  address_prefixes     = ["10.0.3.0/24"]
}