path "transit/encrypt/my-key" {
  capabilities = [ "update" ]
}

path "transit/decrypt/my-key" {
  capabilities = [ "update" ]
}

path "transform/encode/payments" {
  capabilities = [ "create", "update" ]
}

path "transform/decode/payments" {
  capabilities = [ "create", "update" ]
}

path "database/creds/demoapp" {
  capabilities = [ "read", "update" ]
}