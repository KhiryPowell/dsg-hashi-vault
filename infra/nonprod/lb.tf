module "load_balancer" {
  source              = "../modules/load_balancer"
  lb_name             = "lb-${local.workload_name}-${local.environment}-${local.regioncode}-01"
  location            = local.location
  private_ip_address  = "10.176.64.134"
  resource_group_name = module.rg.resource_group_name
  subnet_id           = local.vm_subnet_id
  tags                = local.tags
}
