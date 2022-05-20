resource "azurerm_public_ip" "http" {
  name                = "Frontal-IP"
  location            = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name = azurerm_resource_group.Ciber-Terraform.name
  allocation_method   = "Static"
  tags = {
    environment = "Terraform"
  }
}

resource "azurerm_network_interface" "http" {
  name                = "Frontal-nic"
  location            = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name = azurerm_resource_group.Ciber-Terraform.name

  ip_configuration {
    name                          = "Terraformconfig1"
    subnet_id                     = azurerm_subnet.http.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.http.id
  }
}

resource "azurerm_virtual_machine" "http" {
  name                  = var.http_vm_name
  location              = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name   = azurerm_resource_group.Ciber-Terraform.name
  network_interface_ids = [azurerm_network_interface.http.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "Frontal-osdisk1"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "Frontal"
    admin_username = "ubuntu"
    admin_password = "Dockerdocker1234!"
    ##custom_data    = file("scripts/first-boot.sh")

  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
        key_data = "${file("files/ssh-id.pub")}"
        path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "rg" {
  virtual_machine_id = azurerm_virtual_machine.http.id
  location           = azurerm_resource_group.Ciber-Terraform.location
  enabled            = true

  daily_recurrence_time = "2100"
  timezone              = "Romance Standard Time"


  notification_settings {
    enabled         = false
  }
 }