storage "raft" {
  path = "/vault/data"
  node_id = "vault"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = "true"
  telemetry {
    unauthenticated_metrics_access = true
  }
}

api_addr = "http://vault:8200"
cluster_addr = "https://vault:8201"

cluster_name = "primary"
ui = "true"

telemetry {
  disable_hostname = true
  prometheus_retention_time = "30s"
}