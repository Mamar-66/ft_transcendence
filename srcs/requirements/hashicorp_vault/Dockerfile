FROM hashicorp/vault:1.19.0

RUN apk update && apk add --no-cache jq postgresql-client && mkdir -p /vault/config

COPY ./conf/vault.hcl /vault/config/
COPY ./tools/entrypoint.sh /vault/config/
COPY ./tools/init_vault.sh /vault/config/

RUN chmod +x /vault/config/entrypoint.sh
RUN	chmod +x /vault/config/init_vault.sh

EXPOSE 8200

ENTRYPOINT ["/vault/config/entrypoint.sh"]

#CMD ["vault", "server", "-config=/vault/config/vault.hcl"]
