locals {
  vm05_name       = "vm-vault-np-05"
  vm05_size       = "Standard_D4_v3"
  vm05_avail_zone = "2"
}

module "vm05" {
  source         = "../modules/vm"
  vm_name        = local.vm05_name
  resource_group = module.rg.resource_group_name
  subnet_id      = local.vm_subnet_id
  location       = local.location
  vm_size        = local.vm05_size
  disk_size_gb   = 256
  avail_zone     = local.vm05_avail_zone
  disk_type      = "StandardSSD_LRS"
  os_image       = "/subscriptions/c61b06f4-16b9-4f39-b832-e1012463b0cb/resourceGroups/RG-VRA8-POC/providers/Microsoft.Compute/galleries/DSG.90541.ImageGallery/images/IMG-Ubuntu-2204/versions/0.0.1"
  backend_address_pool_id = module.load_balancer.backend_address_pool_id
}