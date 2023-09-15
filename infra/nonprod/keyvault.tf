module "keyvault" {
  source              = "../modules/keyvault"
  key_vault_name      = "kv-${local.workload_name}-${local.environment}-${local.regioncode}"
  location            = local.location
  resource_group_name = module.rg.resource_group_name
  tags                = local.tags
  network_acls = {
    bypass = "AzureServices"
    default_action = "Deny"
    #VPN ip addresses
    ip_rules = [ "199.30.192.0/22", "208.127.73.132/32", "208.127.73.95/32", "208.127.73.238/32", "208.127.73.208/32", "207.127.183.28/32", "208.127.67.62/32", "208.127.106.149/32", "208.127.106.26/32", "130.41.232.97/32", "130.41.232.165/32", "130.41.232.166/32", "130.41.232.96/32", "208.127.109.104/32", "208.127.109.19/32", "208.127.110.160/32", "208.127.110.120/32", "208.127.110.40/32", "208.127.110.58/32", "130.41.51.109/32", "130.41.51.14/32", "208.127.92.127/32"
    ]
    virtual_network_subnet_ids = [local.vm_subnet_id]
  }
}

resource "azurerm_key_vault_access_policy" "DeveloperEnablement" {
  key_vault_id = module.keyvault.key_vault_id
  tenant_id    = "e04b15c8-7a1e-4390-9b5b-28c7c205a233"
  object_id    = local.de_object_id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey"
  ]
}