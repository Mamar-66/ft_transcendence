#!/bin/bash
set -e

echo "Creating VAULT role and database..."

# 1. Créer l'utilisateur et la base
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE ROLE ${VAULT_USER} WITH LOGIN PASSWORD '${VAULT_PASSWORD}';
    CREATE DATABASE ${VAULT_DB} OWNER ${VAULT_USER};
    GRANT ALL PRIVILEGES ON DATABASE ${VAULT_DB} TO ${VAULT_USER};
EOSQL

# 2. Se connecter à la base créée et préparer les permissions et la table
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$VAULT_DB" <<-EOSQL
    GRANT USAGE ON SCHEMA public TO ${VAULT_USER};
    GRANT CREATE ON SCHEMA public TO ${VAULT_USER};
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ${VAULT_USER};
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ${VAULT_USER};
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ${VAULT_USER};
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO ${VAULT_USER};

    CREATE TABLE IF NOT EXISTS vault_kv_store (
        parent_path TEXT COLLATE "C" NOT NULL,
        path        TEXT COLLATE "C",
        key         TEXT COLLATE "C",
        value       BYTEA,
        CONSTRAINT pkey PRIMARY KEY (path, key)
    );

    CREATE INDEX IF NOT EXISTS parent_path_idx ON vault_kv_store (parent_path);
EOSQL

echo "VAULT database and table ready."
