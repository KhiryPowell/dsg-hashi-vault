terraform {
  required_version = ">=0.15.1"
  required_providers {
    azurerm = {
      version = "~>3.0"
    }
  }
}

resource "random_password" "temp_password" {
  length = 16
  special = true
  override_special = "_%@"
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {

  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "nic_configuration-${var.vm_name}-ue-np"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = var.vm_size
  zone                  = var.avail_zone

  os_disk {
    name                 = "${var.vm_name}-OSDISK"
    caching              = "ReadWrite"
    storage_account_type = var.disk_type
  }

  source_image_id = var.os_image
  
  admin_username                  = "azureuser"
  # admin_password                  = random_password.temp_password.result
 
  # disable_password_authentication = false

  admin_ssh_key {
   username   = "azureuser"
   public_key = tls_private_key.example.public_key_openssh
  }

  #boot_diagnostics {
  #  storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  #}
}