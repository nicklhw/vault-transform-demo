pid_file = "./pidfile"

vault {
  address = "http://vault:8200"
  retry {
    num_retries = 5
  }
}

auto_auth {
  method {
    type      = "approle"

    config = {
      role_id_file_path = "/vault/config/role_id"
      secret_id_file_path = "/vault/config/secret_id"
      secret_id_response_wrapping_path = "auth/approle/role/transform-demo-api/secret-id"
      remove_secret_id_file_after_reading = true
    }
  }

  sink {
    type = "file"
    config = {
      path = "/vault/config/token"
    }
    wrap_ttl = "5m"
  }
}

cache {
  use_auto_auth_token = true
}

listener "tcp" {
  address = "0.0.0.0:8100"
  tls_disable = true
}
