#!/bin/bash
set -euo pipefail

DIR="$( cd .. && pwd )"

export VAULT_INIT_OUTPUT=vault.json
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.root_token')

tput setaf 12 && echo "############## Enable approle auth on Vault ##############"

vault auth enable -max-lease-ttl=8h approle

vault write auth/approle/role/transform-demo-api \
secret_id_ttl=10m \
token_ttl=2h \
token_max_ttl=8h \
policies=payments

tput setaf 12 && echo "############## Fetch approle RoleID ##############"

ROLE_ID=$(vault read -format=json auth/approle/role/transform-demo-api/role-id | jq -r .data.role_id)
echo -n $ROLE_ID > ../vault-agent/role_id

tput setaf 12 && echo "############## Fetch approle SecretID ##############"

SECRET_ID=$(vault write -f -format=json auth/approle/role/transform-demo-api/secret-id | jq -r .data.secret_id)
echo -n $SECRET_ID > ../vault-agent/secret_id

tput setaf 12 && echo "############## Start Vault agent and Transform demo app ##############"; tput sgr0
docker-compose --profile frontend up --detach