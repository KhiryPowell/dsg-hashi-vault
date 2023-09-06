locals {
  vm01_name       = "vm-vault-np-01"
  vm01_size       = "Standard_D4_v3"
  vm01_avail_zone = "1"
}

module "vm01" {
  source         = "../modules/vm"
  vm_name        = local.vm01_name
  resource_group = module.rg.resource_group_name
  subnet_id      = local.vm_subnet_id
  location       = local.location
  vm_size        = local.vm01_size
  disk_size_gb   = 256
  avail_zone     = local.vm01_avail_zone
  disk_type      = "StandardSSD_LRS"
  os_image       = "/subscriptions/c61b06f4-16b9-4f39-b832-e1012463b0cb/resourceGroups/RG-VRA8-POC/providers/Microsoft.Compute/galleries/DSG.90541.ImageGallery/images/IMG-Ubuntu-2204/versions/0.0.1"
}