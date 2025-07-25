# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: joandre- <joandre-@student.42lisboa.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/02 02:45:08 by joandre-          #+#    #+#              #
#    Updated: 2025/07/09 06:57:48 by joandre-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SRC = srcs/compose.yml
NAME = srcs/.env

all: $(NAME)

$(NAME):
	ENV=$(NAME) ./srcs/requirements/tools/setup.sh
	docker compose -f $(SRC) up -d --build

build:
	docker compose -f $(SRC) build

stop:
	docker compose -f $(SRC) stop

up: $(NAME)
	docker compose -f $(SRC) up -d

down:
	docker compose -f $(SRC) down

ps:
	docker compose -f $(SRC) ps -a

restart:
	docker compose -f $(SRC) restart

logs:
	docker compose -f $(SRC) logs -f || true

clean:
	docker compose -f $(SRC) rm -af

fclean: stop clean
	docker system prune -af
	ENV=$(NAME) ./srcs/requirements/tools/cleanup.sh

run: all 
	until nc -z $(shell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' wp-fpm) 9000; do sleep 1; done
	firefox https://$(shell grep DOMAIN $(NAME) | cut -d= -f2) > /dev/null 2>&1 &

re: fclean all

rerun: re run
