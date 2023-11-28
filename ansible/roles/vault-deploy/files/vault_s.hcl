listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address  = "10.176.64.133:8201"
  tls_disable      = 0
  tls_ca_file   = "/etc/ssl/certs/cert.ca"
  tls_cert_file = "/etc/ssl/certs/cert.cer"
  tls_key_file  = "/etc/ssl/certs/cert.key"

}

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

seal "azurekeyvault" {
 tenant_id = "xxxxx"
 client_id = "xxxxx"
 client_secret = "xxxxx"
 vault_name = "dsgplatformvault"
 key_name = "vn01-pks-vault"
 }

ui = true
api_addr = "https://vault-az-np.tools.dcsg.com:8200"
cluster_addr = "https://10.176.64.133:8201"