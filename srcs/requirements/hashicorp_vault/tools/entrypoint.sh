#!/bin/sh

set -e

# Étape 1: Attendre que PostgreSQL soit prêt
echo "⏳ Attente que PostgreSQL soit prêt..."
until pg_isready -h postgres -U "$POSTGRES_USER" -d "$POSTGRES_DB" > /dev/null 2>&1; do
  echo "⏳ PostgreSQL pas encore dispo..."
  sleep 2
done
echo "✅ PostgreSQL est prêt. Lancement de Vault..."

# Démarrer Vault en arrière-plan avec backend local
vault server -config=/vault/config/vault.hcl &

# Récupérer le PID de Vault
VAULT_PID=$!
echo "Vault démarré en arrière-plan avec PID: $VAULT_PID"

## Attendre que Vault soit prêt (vérification de son statut)
#echo "⏳ Attente que Vault soit prêt..."
#until vault status > /dev/null 2>&1; do
#  echo "⏳ Vault pas encore prêt..."
#  sleep 5
#done
#echo "✅ Vault est prêt."

sleep 2
# Initialisation de Vault si ce n'est pas déjà fait
if vault status | grep -q 'Initialized.*false'; then
  echo "🔐 Initialisation de Vault..."
  vault operator init -format=json > /vault/config/keys.json
  echo "✅ Fichier keys.json généré."

  # Extraire les clés d’unseal et les utiliser pour déverrouiller Vault
  for i in 0 1 2; do
    key=$(jq -r ".unseal_keys_b64[$i]" /vault/config/keys.json)
    vault operator unseal "$key"
  done

  echo "✅ Vault initialisé et unseal terminé."
else
  echo "🔓 Vault déjà initialisé. Déverrouillage en cours..."

  # Déverrouiller Vault si déjà initialisé
  for i in 0 1 2; do
    key=$(jq -r ".unseal_keys_b64[$i]" /vault/config/keys.json)
    vault operator unseal "$key"
  done

  echo "✅ Unseal terminé."
fi

# Terminer le processus Vault après l'initialisation et déverrouillage
echo "✅ Vault initialisé et déverrouillé, vous pouvez maintenant utiliser Vault."

wait $VAULT_PID
