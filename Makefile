COMPOSE		= docker-compose -f srcs/docker-compose.yml
DATA_DIR	= $(HOME)/data

all: setup
	$(COMPOSE) up -d --build

setup:
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down --rmi all --volumes
	docker system prune -af
	sudo rm -rf $(HOME)/data/*/*

re: fclean all

.PHONY: all build up down ps clean fclean re