storage_destination "raft" {
  path = "/vault/raft/"
  node_id = "node_1"
}

storage_source "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}

cluster_addr = "https://10.176.64.137:8201"