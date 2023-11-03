listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_cert_file = "/etc/ssl/certs/cert.cer"
  tls_key_file  = "/etc/ssl/certs/cert.key"
  tls_client_ca_file = "/etc/ssl/certs/cert.ca"
}

storage "raft" {
  path = "/vault/raft/"
  node_id = "node_3"

  retry_join {
    leader_tls_servername   = "vault-az-np.tools.dcsg.com"
    leader_api_addr         = "https://10.176.64.137:8200"
    leader_ca_cert_file     = "/etc/ssl/certs/cert.ca"
    leader_client_cert_file = "/etc/ssl/certs/cert.cer"
    leader_client_key_file  = "/etc/ssl/certs/cert.key"
  }

  retry_join {
    leader_tls_servername   = "vault-az-np.tools.dcsg.com"
    leader_api_addr         = "https://10.176.64.132:8200"
    leader_ca_cert_file     = "/etc/ssl/certs/cert.ca"
    leader_client_cert_file = "/etc/ssl/certs/cert.cer"
    leader_client_key_file  = "/etc/ssl/certs/cert.key"
  }

  retry_join {
    leader_tls_servername   = "vault-az-np.tools.dcsg.com"
    leader_api_addr         = "https://10.176.64.136:8200"
    leader_ca_cert_file     = "/etc/ssl/certs/cert.ca"
    leader_client_cert_file = "/etc/ssl/certs/cert.cer"
    leader_client_key_file  = "/etc/ssl/certs/cert.key"
  }

  retry_join {
    leader_tls_servername   = "vault-az-np.tools.dcsg.com"
    leader_api_addr         = "https://10.176.64.135:8200"
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
cluster_addr = "https://10.176.64.133:8201"
disable_mlock = true