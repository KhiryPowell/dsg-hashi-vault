locals {
  # service_principal_id = "cc198c17-41d1-4562-b6fa-d789b72999ec" #srv-developerenablement-np, using sp-azure-onboarding until we hear from security
  environment    = "np"
  location       = "eastus"
  regioncode     = "ue"
  team_group     = "developerenablement"
  de_object_id   = "7381f63a-bde2-4a3a-97e6-c7485dd15bf8"
  workload_name  = "vault"
  vm_subnet_id   = "/subscriptions/3a085d52-0c96-485f-b679-9441a67ed4a2/resourceGroups/rg-networking-devtools-ue-np/providers/Microsoft.Network/virtualNetworks/vnet-devtools-gen-int-np-ue-01/subnets/snet-devtools-gen-int-vault-np-ue-01"
  vm_subnet_name = "snet-devtools-gen-int-vault-np-ue-01"
  tags = {
    "CostCenter"   = "96808"
    "Owner"        = "developerenablement@dcsg.com"
    "Environment"  = local.environment
    "WorkloadName" = local.workload_name
    "ITSMGroup"    = "Tech-DeveloperEnablement"
  }
}