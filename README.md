# Vault Namespace Demo

# Run

```shell
# export Vault license
export VAULT_LICENSE=$(cat ~/Downloads/vault.hclic)     

# Start all containers and minikube
make all
```

# Useful commands
```shell

# login to mysql and show table schema
docker exec -it mysql sh
mysql -uroot -ppassw0rd
use demo;
describe users_tokenization;

```

# Reference
