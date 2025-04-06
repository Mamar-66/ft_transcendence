FROM owasp/modsecurity-crs:nginx-alpine

USER root

# Assurer les bonnes permissions sur le répertoire
RUN apk update && apk add --no-cache \
	nano vim \
	&& rm -rf /var/cache/apk/*

COPY ./tools/help_config.sh /usr/local/bin/fix_nginx.sh
COPY ./conf/nginx.conf /etc/nginx/nginx.conff

RUN chmod +x /usr/local/bin/fix_nginx.sh

# Copier la configuration ModSecurity (si tu veux en personnaliser une)
COPY ./conf/modsecurity.conf /etc/nginx/modsec.conf

# Copier des règles de sécurité supplémentaires (si besoin)
# COPY custom_rules/ /usr/local/modsecurity-crs/base_rules/

# Exposer les ports 80 (HTTP) et 443 (HTTPS) pour Nginx
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/fix_nginx.sh"]

CMD ["nginx", "-g", "daemon off;"]
