
VAULT_DB_COMPOSE = ./srcs/vault_db-docker-compose.yml
DJANGO = ./srcs/django-docker-compose.yml

up: create_network vault_db-up django_up

create_network:
	@docker network inspect vault_db_django_network > /dev/null 2>&1 || docker network create vault_db_django_network
	@echo "\033[0;32mNetwork 'vault_db_django_network' is ready!\033[0m"

vault_db-up:
	docker compose -f $(VAULT_DB_COMPOSE) build
	docker compose -f $(VAULT_DB_COMPOSE) up -d
	@echo "\033[1;33mWaiting for Vault to be ready (inside container)...\033[0m"
	@until [ -f ./srcs/requirements/hashicorp_vault/vault_status.txt ] && grep -q "vault ready" ./srcs/requirements/hashicorp_vault/vault_status.txt; do \
		echo "\033[1;33mVault not ready yet...\033[0m"; \
		sleep 2; \
	done
	@echo "\033[0;32mVault is ready!\033[0m"

#django_up:
#	docker compose -f $(DJANGO) build
#	docker compose -f $(DJANGO) up -d
#	@echo "\033[0;32mDjango is ready!\033[0m"

down:
	@docker compose -f ./srcs/vault_db-docker-compose.yml down

re:
	@make down
	@make all

clean:
	@echo "\033[1;33mStopping all containers...\033[0m"
	@docker ps -aq | xargs -r docker stop
	@echo "\033[1;33mRemoving all containers...\033[0m"
	@docker ps -aq | xargs -r docker rm
	@echo "\033[1;33mRemoving all images...\033[0m"
	@docker images -aq | xargs -r docker rmi -f
	@echo "\033[1;33mRemoving all volumes...\033[0m"
	@docker volume ls -q | xargs -r docker volume rm
	@echo "\033[1;33mRemoving all custom networks...\033[0m"
	@docker network ls --filter type=custom -q | grep -q . && docker network ls --filter type=custom -q | xargs -r docker network rm || echo "No custom networks to remove"
	@echo "\033[1;33mCleaning vault status file...\033[0m"
	@> ./srcs/requirements/hashicorp_vault/vault_status.txt
	@echo "\033[1;32mCleaning complete!\033[0m"

.PHONY: all down re clean create_network vault_db-up django_up
