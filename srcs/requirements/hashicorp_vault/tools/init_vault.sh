#!/bin/sh

sleep 1

VAULT_KEYS_FILE="/vault/config/keys.json"
DJANGO_USER_MANAGER="django_user_manager"

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

ROOT_TOKEN=$(jq -r ".root_token" "$VAULT_KEYS_FILE")

# Export the root token so Vault commands use it
export VAULT_TOKEN="$ROOT_TOKEN"

# Enable KV if not enabled
if ! vault secrets list | grep -q '^secret/'; then
  echo "Enabling kv-v2 at path secret/"
  vault secrets enable -path=secret kv-v2
fi

vault secrets enable database

vault auth enable approle
vault policy write django-policy django-policy.hcl

vault write auth/approle/role/django-role \
  token_policies="django-policy"
vault read auth/approle/role/django-role/role-id > $DJANGO_USER_MANAGER
vault write -f auth/approle/role/django-role/secret-id | grep "secret_id " >> $DJANGO_USER_MANAGER

echo "Secret added. Script finished."
echo "vault ready" > /vault/ready/vault_status.txt
