module "sa" {
  source              = "../modules/storage_account"
  name                = "stdsgvaultnpue"
  resource_group_name = module.rg.resource_group_name
  location            = local.location
  ip_range_filter     = []
  firewall_subnet_ids = [local.vm_subnet_id]
  firewall_tags       = ["CLIENT-VPN", "GITHUB-ACTIONS"]
  tags                = local.tags
}

resource "azurerm_storage_container" "raftbackup" {
  name                  = "raftbackup"
  storage_account_name  = module.sa.name
  container_access_type = "private"
}