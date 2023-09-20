terraform {
  required_version = ">=0.15.1"
  required_providers {
    azurerm = {
      version = "~>3.0"
    }
  }
}

# Create network interface
resource "azurerm_network_interface" "vm" {

  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "nic_configuration-${var.vm_name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  network_interface_id    = azurerm_network_interface.vm.id
  ip_configuration_name   = "nic_configuration-${var.vm_name}"
  backend_address_pool_id = var.backend_address_pool_id
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.vm.id]
  size                  = var.vm_size
  zone                  = var.avail_zone

  os_disk {
    name                 = "${var.vm_name}-OSDISK"
    caching              = "ReadWrite"
    storage_account_type = var.disk_type
    disk_size_gb         = var.disk_size_gb
  }

  source_image_id = var.os_image

  admin_username = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  #boot_diagnostics {
  #  storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  #}
}