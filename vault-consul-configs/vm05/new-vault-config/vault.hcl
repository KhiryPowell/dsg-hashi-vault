listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_cert_file = "/etc/ssl/certs/cert.cer"
  tls_key_file  = "/etc/ssl/certs/cert.key"
  tls_client_ca_file = "/etc/ssl/certs/cert.ca"
}

storage "raft" {
  path = "/vault/raft/"
  node_id = "node_5"

  retry_join {
    leader_tls_servername   = "vault-az-np.tools.dcsg.com"
    auto_join = "provider=azure tag_name=hashicorp tag_value=vault tenant_id=e04b15c8-7a1e-4390-9b5b-28c7c205a233 client_id=19902587-34f3-4241-93ed-b15f604789b1 subscription_id=3a085d52-0c96-485f-b679-9441a67ed4a2 secret_access_key=...dont use quotes for secret"
    leader_ca_cert_file     = "/etc/ssl/certs/cert.ca"
    leader_client_cert_file = "/etc/ssl/certs/cert.cer"
    leader_client_key_file  = "/etc/ssl/certs/cert.key"
  }
}

seal "azurekeyvault" {
 tenant_id = "e04b15c8-7a1e-4390-9b5b-28c7c205a233"
 client_id = "c753e788-47c2-4f11-9c28-5929124f7574"
 client_secret = "HiQcpTDJH.8-u08K9YF.3i1~z6l2721fS~"
 vault_name = "dsgplatformvault"
 key_name = "vn01-pks-vault"
 }

ui = true
api_addr = "https://vault-az-np.tools.dcsg.com:8200"
cluster_addr = "https://10.176.64.135:8201"
disable_mlock = true