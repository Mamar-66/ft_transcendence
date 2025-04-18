FROM postgres:17.3

RUN  mkdir -p /vault/conf

COPY ./conf/init_vault.sh /docker-entrypoint-initdb.d/init-db.sh

RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

#ENTRYPOINT ["/vault/conf/init_vault.sh"]
