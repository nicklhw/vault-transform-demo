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
- [Vault Transform Demo](https://github.com/tkaburagi/vault-transformation-demo/tree/master)
- [Vault Transform Tutorial](https://developer.hashicorp.com/vault/tutorials/adp/transform)
- [Vault Tokenization Tutorial](https://developer.hashicorp.com/vault/tutorials/adp/tokenization)
- [Vault Transform Secrets Engine API](https://developer.hashicorp.com/vault/api-docs/secret/transform#transform-secrets-engine-api)
- [Vault Demo by Nicholas Jackson](https://github.com/nicholasjackson/demo-vault)
- [Spring Cloud Vault](https://cloud.spring.io/spring-cloud-vault/reference/html/#_quick_start)