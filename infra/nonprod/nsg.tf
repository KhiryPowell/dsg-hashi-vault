module "nsg" {
  source              = "../modules/nsg"
  name                = "nsg-${local.vm_subnet_name}"
  location            = local.location
  resource_group_name = module.rg.resource_group_name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "Allow_https_csc" {
  name                        = "Allow_https"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     =  ["10.0.0.0/8","172.20.0.0/16","172.31.0.0/16","172.26.0.0/16"]
  destination_address_prefix  = "*"
  resource_group_name         = module.rg.resource_group_name
  network_security_group_name = module.nsg.name
}

resource "azurerm_network_security_rule" "Allow_ssh_vpn" {
  name                        = "Allow_ssh_vpn"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = ["172.20.0.0/16","172.31.0.0/16","172.26.0.0/16"]
  destination_address_prefix  = "*"
  resource_group_name         = module.rg.resource_group_name
  network_security_group_name = module.nsg.name
}

resource "azurerm_network_security_rule" "Allow_ssh_github" {
  name                        = "Allow_ssh_github"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = ["10.121.69.0/24"]
  destination_address_prefix  = "*"
  resource_group_name         = module.rg.resource_group_name
  network_security_group_name = module.nsg.name
}

resource "azurerm_network_security_rule" "Allow_ansible" {
  name                        = "Allow_ansible"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = ["10.221.9.192"]
  destination_address_prefix  = "*"
  resource_group_name         = module.rg.resource_group_name
  network_security_group_name = module.nsg.name
}