
output "private_ip_address" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "private_key" {
  value = tls_private_key.ssh.private_key_openssh
}