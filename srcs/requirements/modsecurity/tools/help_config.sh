#!/bin/sh

# Supprimer nginx.conf s'il existe
if [ -f /etc/nginx/nginx.conf ]; then
    echo "Suppression de /etc/nginx/nginx.conf"
    rm /etc/nginx/nginx.conf
fi

# Supprimer default.conf s'il existe
if [ -f /etc/nginx/conf.d/default.conf ]; then
    echo "Suppression de /etc/nginx/conf.d/default.conf"
    rm /etc/nginx/conf.d/default.conf
fi

# Renommer nginx.conff en nginx.conf
if [ -f /etc/nginx/nginx.conff ]; then
    echo "Renommage de /etc/nginx/nginx.conff en /etc/nginx/nginx.conf"
    mv /etc/nginx/nginx.conff /etc/nginx/nginx.conf
else
    echo "Erreur : /etc/nginx/nginx.conff introuvable !" >&2
    exit 1
fi

# Renommer default.conff en default.conf
if [ -f /etc/nginx/conf.d/default.conff ]; then
    echo "Renommage de /etc/nginx/conf.d/default.conff en /etc/nginx/conf.d/default.conf"
    mv /etc/nginx/conf.d/default.conff /etc/nginx/conf.d/default.conf
else
    echo "Erreur : /etc/nginx/conf.d/default.conff introuvable !" >&2
    exit 1
fi

# Assurer que /var/run existe pour le pid
if [ ! -d /var/run ]; then
    echo "Création du dossier /var/run"
    mkdir -p /var/run
fi

touch /var/run/nginx.pid
chmod 755 /var/run

# Lancer nginx
if [ -f /etc/nginx/nginx.conf ]; then
    echo "Rechargement de Nginx..."
    exec nginx -g "daemon off;"
else
    echo "Erreur : /etc/nginx/nginx.conf est introuvable après renommage !" >&2
    exit 1
fi
