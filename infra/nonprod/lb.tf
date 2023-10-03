module "load_balancer" {
  source              = "../modules/load_balancer"
  lb_name             = "lb-${local.workload_name}-${local.environment}-${local.regioncode}-01"
  location            = local.location
  private_ip_address  = "10.176.64.134"
  resource_group_name = module.rg.resource_group_name
  subnet_id           = local.vm_subnet_id
  tags                = local.tags
}



# tls {
#   defaults {
#      ca_file = "/etc/consul.d/certs/consul-agent-ca.pem"
#      cert_file = "/etc/consul.d/certs/dc1-server-consul-0.pem"
#      key_file = "/etc/consul.d/certs/dc1-server-consul-0-key.pem"

#      verify_incoming = true
#      verify_outgoing = true
#   }
#   internal_rpc {
#      verify_server_hostname = true
#   }
# }

# auto_encrypt {
#  allow_tls = true
# }