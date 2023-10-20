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
cp cert.ca ~/etc/ssl/certs/
cp cert.cer ~/etc/ssl/certs/
cp cert.key ~/etc/ssl/certs/
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
To restore the consul Snapshot, follow the steps here: https://dcsgcloud.atlassian.net/wiki/spaces/DEV/pages/20487732/Vault+Restore+Procedures+from+Backup

Extract Snapshot File
Restore Snapshot (STOP at Step3. Step 3 points to VP01 recovery keys so make sure it's VN01 as I did this for nonprod)