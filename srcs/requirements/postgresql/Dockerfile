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

FROM postgres:17.3

COPY --from=builder /certs /certs

RUN  mkdir -p /vault/conf && \
	 chmod 600 /certs/privatKey.key && \
	 chown postgres:postgres /certs/privatKey.key

COPY ./conf/init_vault.sh /docker-entrypoint-initdb.d/init-db.sh

RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh
