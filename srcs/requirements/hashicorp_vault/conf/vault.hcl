
storage "postgresql" {
  connection_url = "postgresql://vault:vault1234@postgres:5432/vault_db?sslmode=require"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_cert_file = "/certs/publicCertificat.crt"
  tls_key_file  = "/certs/privatKey.key"
}

api_addr = "https://hashicorp_vault:8200"
# ui = true
disable_mlock = true 
