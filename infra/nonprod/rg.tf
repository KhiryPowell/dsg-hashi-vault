module "rg" {
  source               = "../modules/resource_group"
  # service_principal_id = local.service_principal_id #using sp-azure-onboarding until we hear from security
  workload_name        = local.workload_name
  env                  = local.environment
  team_group           = local.team_group
  location = local.location
  tags = local.tags
}
