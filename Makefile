COMPOSE = docker-compose -f srcs/docker-compose.yml

all:
	$(COMPOSE) up -d --build

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down --rmi all --volumes
	docker system prune -af
	sudo rm -rf /home/jleiva-g/data/*/*

re: fclean all

.PHONY: all build up down clean fclean re