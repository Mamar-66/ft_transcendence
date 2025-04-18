
storage "postgresql" {
  connection_url = "postgresql://vault:vault1234@postgres:5432/vault_db?sslmode=disable"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://localhost:80"
ui = true
disable_mlock = true
