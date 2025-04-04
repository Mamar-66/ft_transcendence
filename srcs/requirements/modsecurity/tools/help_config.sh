#!/bin/sh

# Supprimer nginx.conf s'il existe
if [ -f /etc/nginx/nginx.conf ]; then
    echo "Suppression de /etc/nginx/nginx.conf"
    rm /etc/nginx/nginx.conf
fi

# Renommer nginx.conff en nginx.conf
if [ -f /etc/nginx/nginx.conff ]; then
    echo "Renommage de /etc/nginx/nginx.conff en /etc/nginx/nginx.conf"
    mv /etc/nginx/nginx.conff /etc/nginx/nginx.conf
else
    echo "Erreur : /etc/nginx/nginx.conff introuvable !" >&2
    exit 1
fi

# Vérifier et recréer /var/run/nginx.pid si nécessaire
if [ ! -d /var/run ]; then
    echo "Création du dossier /var/run"
    mkdir -p /var/run
fi

touch /var/run/nginx.pid
chmod 755 /var/run

# Démarrer Nginx si le fichier de conf existe bien
if [ -f /etc/nginx/nginx.conf ]; then
    echo "Rechargement de Nginx..."
    nginx -s reload
else
    echo "Erreur : /etc/nginx/nginx.conf est introuvable après renommage !" >&2
    exit 1
fi

exec nginx -g "daemon off;"