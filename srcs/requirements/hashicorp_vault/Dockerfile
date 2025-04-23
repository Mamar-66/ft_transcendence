FROM debian:bookworm-slim AS builder

RUN apt-get update && \
    apt-get install -y git openssl && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/openssl.cnf /etc/ssl/

RUN mkdir -p /certs && \
    openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /certs/publicCertificat.crt \
    -keyout /certs/privatKey.key \
	-config /etc/ssl/openssl.cnf

FROM hashicorp/vault:1.19.0

COPY --from=builder /certs /certs

RUN apk update && \
	apk add --no-cache jq postgresql-client && \
	mkdir -p /vault/config

COPY ./conf/vault.hcl /vault/config/
COPY ./tools/entrypoint.sh /vault/config/
COPY ./tools/init_vault.sh /vault/config/

RUN chmod +x /vault/config/entrypoint.sh
RUN	chmod +x /vault/config/init_vault.sh

#EXPOSE 8200

ENTRYPOINT ["/vault/config/entrypoint.sh"]
