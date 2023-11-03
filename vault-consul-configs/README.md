Firewall rules required:
port 443 and 8200 open from internal network
port 22 open from VPN

Gather all ssh private keys from Terraform.

Change your directory to point to /infra
```
cd /infra
```

To perform the following steps, you need to have the following
ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID, ARM_SUBSCRIPTION_ID

xxxxx = the real vaules
Run the following export commands in your local terminal
```
export ARM_CLIENT_ID="xxxxx"
export ARM_CLIENT_SECRET="xxxxx"
export ARM_TENANT_ID="xxxxx"
export ARM_SUBSCRIPTION_ID="xxxxx"
```

Run the following command to get ssh private key which will be used to login to Azure VM. The following puts the private keys on your local machine.
```
terraform state list
terraform output -raw tls_private_key > ~/.ssh/vault_tls_private_key
terraform output -raw tls_private_key02 > ~/.ssh/vault_tls_private_key02
terraform output -raw tls_private_key03 > ~/.ssh/vault_tls_private_key03
terraform output -raw tls_private_key04 > ~/.ssh/vault_tls_private_key04
terraform output -raw tls_private_key05 > ~/.ssh/vault_tls_private_key05
chmod 0600 ~/.ssh/vault_tls_private_key
chmod 0600 ~/.ssh/vault_tls_private_key02
chmod 0600 ~/.ssh/vault_tls_private_key03
chmod 0600 ~/.ssh/vault_tls_private_key04
chmod 0600 ~/.ssh/vault_tls_private_key05
```

SSH into vms using seperate terminals
```
ssh -i ~/.ssh/vault_tls_private_key azureuser@{ip address of vm01}
ssh -i ~/.ssh/vault_tls_private_key02 azureuser@{ip address of vm02}
ssh -i ~/.ssh/vault_tls_private_key03 azureuser@{ip address of vm03}
ssh -i ~/.ssh/vault_tls_private_key04 azureuser@{ip address of vm04}
ssh -i ~/.ssh/vault_tls_private_key05 azureuser@{ip address of vm05}
```

Install Consul binary 1.8.2 and configure Consul first on all 5 vms to create a HA cluster
Install Vault binary 1.5.4 on vm01 and vm02 after Consul is configured

Place tools tls certs for Vault in the following path 
```
cp cert.ca /etc/ssl/certs/
cp cert.cer /etc/ssl/certs/
cp cert.key /etc/ssl/certs/
```

Tenant ID, Client ID, and Client Secret can be found below. This is needed for the vault config files which will be used to unseal Vault and connect to KeyVault:
```
credhublogin concourse
tenant_id="$(az account show -o json | jq  -r .tenantId)"
client_id="$(credhub get -q -n /concourse/vn01-pks/vault/azure_client_id)"
client_secret="$(credhub get -q -n /concourse/vn01-pks/vault/azure_client_secret)"
```

Configs for VM01
 Place the config files here:
 /etc/vault/vault_s1.hcl
 /usr/local/etc/consul/consul_c1.json
 /etc/systemd/system/consul.service
 /etc/systemd/system/vault.service

```
 sudo systemctl daemon-reload
 sudo systemctl start consul
 sudo systemctl start vault
 sudo systemctl status consul
 sudo systemctl status vault
 sudo consul members
 vault operator init -tls-server-name="vault-az-np.tools.dcsg.com"
```

Configs for VM02
 Place the config files here:
 /etc/vault/vault_s2.hcl
 /usr/local/etc/consul/consul_c2.json
 /etc/systemd/system/consul.service
 /etc/systemd/system/vault.service

```
 sudo systemctl daemon-reload
 sudo systemctl start consul
 sudo systemctl start vault
 sudo systemctl status consul
 sudo systemctl status vault
 sudo consul members
 vault operator init -tls-server-name="vault-az-np.tools.dcsg.com"
```

Configs for VM03
 Place the config files here:
 /usr/local/etc/consul/consul_s1.json
 /etc/systemd/system/consul.service

```
 sudo systemctl daemon-reload
 sudo systemctl start consul
 sudo systemctl status consul
 sudo consul members
```

Configs for VM04
 Place the config files here:
 /usr/local/etc/consul/consul_s2.json
 /etc/systemd/system/consul.service

```
 sudo systemctl daemon-reload
 sudo systemctl start consul
 sudo systemctl status consul
 sudo consul members
```

Configs for VM05
 Place the config files here:
 /usr/local/etc/consul/consul_s3.json
 /etc/systemd/system/consul.service

```
 sudo systemctl daemon-reload
 sudo systemctl start consul
 sudo systemctl status consul
 sudo consul members
```

Consul Snapshot Restore

Get the snapshot from the following for nonprod
https://concourse.tools.dcsg.com/teams/main/pipelines/backup-nonprod-vault

Located in snapshot-vault, you will be able to see the storage account where the snapshot is stored

To restore the consul Snapshot, follow the steps here: https://dcsgcloud.atlassian.net/wiki/spaces/DEV/pages/20487732/Vault+Restore+Procedures+from+Backup

Extract Snapshot File

Restore Snapshot (STOP at Step3. Step 3 points to VP01 recovery keys so make sure it's VN01 as I did this for nonprod)

***Update/Install latest version of Vault***

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault
```


***Migrate from Consul to Raft***

Migration steps are found here: https://developer.hashicorp.com/vault/tutorials/raft/raft-migration

On the Consul server cluster that contains the Vault data to be saved in a snapshot, execute the following command from either a Consul server directly or any system running a Consul client agent connected to the server cluster.

Before I saved the consul snapshot I went to the /etc/vault/ directory

```
cd /etc/vault/
consul snapshot save backup.snap
```

Migarate Vault Storage

*Note
Vault will need to be offline on the node during the migration process
```
sudo systemctl stop vault
```

Perform the migration step on one of the nodes in the cluster which will become the leader node.

I did this on vm01.

Create a migration file in /etc/vault. (This is what I used for Nonprod and this can be found in vault-consul-configs/vm01/new-vault-config/migrate.hcl  Make sure the appropriate cluster_addr is set for Prod)

Make /vault/raft directory which will be used to store raft config

```
cd /
sudo mkdir /vault
sudo mkdir /vault/raft
sudo chown azureuser:azureuser -R /vault
```

This step only needs to be performed 1 time

```
vault operator migrate -config=migrate.hcl
```

Assume that the following is your new Vault server configuration

Update vault_s#.hcl (This is what I used for nonprod and this can be found in vault-consul-configs/vm01/new-vault-config/vault_s1.hcl)

You can start the Vault server using the new server configuration pointing to the raft storage
```
sudo systemctl start vault
```
Login to Vault
```
vault login -tls-server-name="vault-az-np.tools.dcsg.com"
```
You can get the root token here, perform this on your local machine terminal
```
credhub get -q -n /concourse/vn01-pks/vault/azure_client_secret
```
To look at raft peers run the following.
```
vault operator raft list-peers -tls-server-name="vault-az-np.tools.dcsg.com"
```

***New Vault Configs***

After completing the migration, update the configs for Vault

New configs files for vault are located under vm folder
For vm03, vm05, and vm05 the vault config files are placed under /etc/vault.d/vault_s#.hcl

Make /vault/raft directory which will be used to store raft config

```
cd /
sudo mkdir /vault
sudo mkdir /vault/raft
sudo chown azureuser:azureuser -R /vault
```

