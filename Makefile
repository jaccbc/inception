# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: joandre- <joandre-@student.42lisboa.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/02 02:45:08 by joandre-          #+#    #+#              #
#    Updated: 2025/07/05 20:26:27 by joandre-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DOCK = $(shell docker ps -a -f "status=exited" --format "{{.Names}}")
SRC = srcs/compose.yml
NAME = srcs/.env

all: $(NAME)

$(NAME):
	ENV=$(NAME) ./srcs/requirements/tools/setup.sh
	docker compose -f $(SRC) up -d --build

up: 
	docker compose -f $(SRC) up $(DOCK) -d

down:
	docker compose -f $(SRC) down

ps:
	docker compose -f $(SRC) ps -a

logs:
	docker compose -f $(SRC) logs -f || true

clean:
	docker compose -f $(SRC) rm -f -a

fclean:
	docker compose -f $(SRC) stop
	docker system prune -a -f
	ENV=$(NAME) ./srcs/requirements/tools/cleanup.sh

re: fclean all
