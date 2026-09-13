DATA_DIR = /home/hrhilane/data
COMPOSE = docker compose -f srcs/docker-compose.yml

NAME := inception
TARGET := $(NAME)

.DEFAULT_GOAL := $(TARGET)

$(DATA_DIR)/mariadb $(DATA_DIR)/wordpress:
	@mkdir -p $@

$(TARGET): $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	$(COMPOSE) up -d --build

.PHONY: all up down logs clean fclean re

all: $(TARGET)

up:
	@$(COMPOSE) up -d

down:
	@$(COMPOSE) down

logs:
	@$(COMPOSE) logs -f

clean: down
	@$(COMPOSE) down -v --rmi all
	@docker system prune -af

fclean: clean
	@sudo rm -rf $(DATA_DIR)

re: fclean all
