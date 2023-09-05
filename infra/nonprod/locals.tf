locals {
  service_principal_id = "cc198c17-41d1-4562-b6fa-d789b72999ec" #srv-developerenablement-np 
  environment = "np"
  location = "eastus"
  team_group = "developerenablement"
  tags = {
    "CostCenter"   = "96808"
    "Owner"        = "developerenablement@dcsg.com"
    "Environment"  = local.environment
    "WorkloadName" = "vault"
    "ITSMGroup"    = "Tech-DeveloperEnablement"
  }
}