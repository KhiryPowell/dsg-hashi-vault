output "load_balancer_id" {
  value = azurerm_lb.vault_lb.id
}

output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.vault_backend.id
}