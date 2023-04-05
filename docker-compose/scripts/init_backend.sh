#!/bin/bash
set -euo pipefail

export VAULT_INIT_OUTPUT=vault.json

tput setaf 12 && echo "############## Initializing Vault ##############"
export VAULT_ADDR=http://localhost:8200
sleep 5
vault operator init -format=json -n 1 -t 1 > ${VAULT_INIT_OUTPUT}

export VAULT_TOKEN=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.root_token')
tput setaf 12 && echo "############## Root VAULT TOKEN is: $VAULT_TOKEN ##############"

tput setaf 12 && echo "############## Unseal Vault ##############"
export VAULT_ADDR=http://localhost:8200

export unseal_key=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.unseal_keys_b64[0]')
vault operator unseal ${unseal_key}

tput setaf 12 && echo "############## Vault Cluster members ##############"
vault operator members

export VAULT_TOKEN=$(cat ${VAULT_INIT_OUTPUT} | jq -r '.root_token')

tput setaf 12 && echo "############## Configure polices on Vault ##############"

vault policy write admin ./admin_policy.hcl
vault policy write payments ./payments.hcl

tput setaf 12 && echo "############## Enable userpass auth on Vault ##############"

vault auth enable -max-lease-ttl=1h userpass

vault write auth/userpass/users/admin password="passw0rd" policies="admin"

tput setaf 12 && echo "############## Enable audit device ##############"

vault audit enable file file_path=/var/log/vault/vault-audit.log mode=744

tput setaf 12 && echo "############## Setup Database secret engine ##############"

sleep 10

vault secrets enable database

vault write database/roles/demoapp \
db_name=mysql-demo-db \
creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT,INSERT,UPDATE ON demo.users_tokenization TO '{{name}}'@'%';" \
default_ttl="8h" \
max_ttl="8h"

vault write database/config/mysql-demo-db \
plugin_name=mysql-legacy-database-plugin \
connection_url="{{username}}:{{password}}@tcp(mysql:3306)/" \
allowed_roles="demoapp" \
username="root" \
password="passw0rd"

tput setaf 12 && echo "############## Setup Transit secret engine ##############"

vault secrets enable transit

vault write -f transit/keys/my-key

tput setaf 12 && echo "############## Setup Transform secret engine for FPE ##############"

vault secrets enable transform

vault write transform/role/payments \
transformations=creditcard-numeric,creditcard-numericupper,creditcard-symbolnumericalpha,email,email-exdomain,ccn-masking,default-tokenization,convergent-tokenization

vault write transform/transformation/creditcard-numeric \
type=fpe \
template=builtin/creditcardnumber \
allowed_roles=payments \
tweak_source=internal

vault write transform/template/creditcard-to-numericandupper \
type=regex \
pattern='([0-9A-Z]{4})-([0-9A-Z]{4})-([0-9A-Z]{4})-([0-9A-Z]{4})' \
alphabet=builtin/alphanumericupper

vault write transform/transformation/creditcard-numericupper \
type=fpe \
template=creditcard-to-numericandupper \
tweak_source=internal \
allowed_roles=payments

vault write transform/alphabet/symbolnumericalpha \
alphabet="0123456789._%+~#@&/,=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

vault write transform/template/creditcard-to-symbolnumericalpha \
type=regex \
pattern='([0-9A-Za-z._%+~#@&/,=$]{4})-([0-9A-Za-z._%+~#@&/,=$]{4})-([0-9A-Za-z._%+~#@&/,=$]{4})-([0-9A-Za-z._%+~#@&/,=$]{4})' \
alphabet=symbolnumericalpha

vault write transform/transformation/creditcard-symbolnumericalpha \
type=fpe \
template=creditcard-to-symbolnumericalpha \
tweak_source=internal \
allowed_roles=payments

vault write transform/alphabet/localemailaddress \
alphabet=".0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

vault write transform/template/email-exdomain \
alphabet=localemailaddress \
pattern='^([\w-\.]+)@[\w-\.]+\.+[\w-\.]{2,4}$' \
type=regex

vault write transform/transformation/email-exdomain \
type=fpe \
template=email-exdomain \
allowed_roles=payments \
tweak_source=internal

vault write transform/template/email-template \
alphabet=localemailaddress \
pattern='^([\w-\.]+)@([\w-\.]+)\.+([\w-\.]{2,4})$' \
type=regex

vault write transform/transformation/email \
type=fpe \
template=email-template \
allowed_roles=payments \
tweak_source=internal

vault write transform/template/ccn-masking \
type=regex \
pattern='\d\d\d\d-\d\d\d\d-\d\d(\d{2}|[A-Z]{4})-(\d{4}|[A-Z]{4})' \
alphabet=builtin/alphanumericupper

vault write transform/transformation/ccn-masking \
type=masking \
template=ccn-masking \
masking_character=# \
allowed_roles=payments

tput setaf 12 && echo "############## Setup Transform secret engine for Tokenization ##############"

vault write transform/stores/mysql \
type=sql \
driver=mysql \
supported_transformations=tokenization \
connection_string='{{username}}:{{password}}@tcp(mysql:3306)/demo?parseTime=true' \
username=root \
password=passw0rd

vault write transform/stores/mysql/schema transformation_type=tokenization \
username=root password=passw0rd

vault write transform/transformations/tokenization/default-tokenization \
allowed_roles=payments \
stores=mysql

vault write transform/transformations/tokenization/convergent-tokenization \
allowed_roles=payments \
convergent=true
stores=mysql

tput setaf 12 && echo "############## Please Run: export VAULT_TOKEN=${VAULT_TOKEN} ##############"