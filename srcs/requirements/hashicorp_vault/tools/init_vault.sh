#!/bin/sh

sleep 1

VAULT_KEYS_FILE="/vault/config/keys.json"

# Vault operator init
if vault status | grep -q 'Initialized.*false'; then
  echo "Init Vault..."
  vault operator init -format=json > "$VAULT_KEYS_FILE"
  echo "File keys.json generated."

  # Unseal
  for i in 0 1 2; do
    key=$(jq -r ".unseal_keys_b64[$i]" "$VAULT_KEYS_FILE")
    vault operator unseal "$key"
  done

  echo "Vault initialized"
else
  echo "Vault already initialized, unsealing..."
  for i in 0 1 2; do
    key=$(jq -r ".unseal_keys_b64[$i]" "$VAULT_KEYS_FILE")
    vault operator unseal "$key"
  done
fi

echo "Vault unseal complete."

# Get root token from keys.json
ROOT_TOKEN=$(jq -r ".root_token" "$VAULT_KEYS_FILE")

# Enable KV if not enabled
if ! vault secrets list -token="$ROOT_TOKEN" | grep -q '^secret/'; then
  echo "Enabling kv-v2 at path secret/"
  vault secrets enable -path=secret kv-v2 -token="$ROOT_TOKEN"
fi

echo "Secret added. Script finished."
