#!/bin/sh

set -e

# Étape 1: Wait posgresql
until pg_isready -h postgres -U "$POSTGRES_USER" -d "$POSTGRES_DB" > /dev/null 2>&1; do
  echo "Wait PostgreSQL..."
  sleep 2
done
echo "PostgreSQL OK, Started Vault..."

# vault started backend

/vault/config/init_vault.sh &

vault server -config=/vault/config/vault.hcl
