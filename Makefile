all:
	@docker compose -f ./srcs/docker-compose.yml build --no-cache
	@docker compose -f ./srcs/docker-compose.yml up -d
down:
	@docker compose -f ./srcs/docker-compose.yml down

re:
	@make down
	@make all

clean:
	@docker ps -aq | xargs -r docker stop; \
	docker ps -aq | xargs -r docker rm; \
	docker images -aq | xargs -r docker rmi -f; \
	docker volume ls -q | xargs -r docker volume rm; \
	docker network ls --filter type=custom -q | xargs -r docker network rm

.PHONY: all down re clean