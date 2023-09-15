output "key_vault_name" {
  value = azurerm_key_vault.vault_kv.name
}

output "key_vault_id" {
  value = azurerm_key_vault.vault_kv.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.vault_kv.vault_uri
}