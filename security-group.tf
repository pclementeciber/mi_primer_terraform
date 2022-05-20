resource "azurerm_network_security_group" "http" {
  name                = "http"
  location            = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name = azurerm_resource_group.Ciber-Terraform.name

  security_rule {
    name                       = "ssh"
    description                = "Allow SSH access TF"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    description                = "Allow HTTP access TF"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}