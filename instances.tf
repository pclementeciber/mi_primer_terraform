resource "azurerm_public_ip" "http" {
  for_each = var.array_de_vm
  name                = "${each.key}-IP"
  location            = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name = azurerm_resource_group.Ciber-Terraform.name
  allocation_method   = "Static"
  tags = {
    environment = "Terraform"
  }
}

resource "azurerm_network_interface" "http" {
  for_each = var.array_de_vm
  name                = "${each.key}-nic"
  location            = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name = azurerm_resource_group.Ciber-Terraform.name

  ip_configuration {
    name                          = "Terraform${each.key}"
    subnet_id                     = azurerm_subnet.http.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.http["${each.key}"].id
  }
}

resource "azurerm_virtual_machine" "http" {
  for_each = var.array_de_vm
  name                  = "${each.key}"
  location              = azurerm_resource_group.Ciber-Terraform.location
  resource_group_name   = azurerm_resource_group.Ciber-Terraform.name
  network_interface_ids = [azurerm_network_interface.http["${each.key}"].id]
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
    name              = "${each.key}-osdisk1"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${each.key}"
    admin_username = "ubuntu"
    admin_password = "Dockerdocker1234!"
    ##custom_data    = file("scripts/first-boot.sh")

  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
        # key_data = "${file("files/ssh-id.pub")}"
        key_data = "${var.ssh_key}"
        path = "/home/ubuntu/.ssh/authorized_keys"
    }
  }
}


resource "azurerm_dev_test_global_vm_shutdown_schedule" "rg" {
  for_each = var.array_de_vm
  virtual_machine_id = azurerm_virtual_machine.http["${each.key}"].id
  location           = azurerm_resource_group.Ciber-Terraform.location
  enabled            = true

  daily_recurrence_time = "2100"
  timezone              = "Romance Standard Time"


  notification_settings {
    enabled         = false
  }
 }