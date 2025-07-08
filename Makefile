# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: joandre- <joandre-@student.42lisboa.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/02 02:45:08 by joandre-          #+#    #+#              #
#    Updated: 2025/07/08 07:35:45 by joandre-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SRC = srcs/compose.yml
NAME = srcs/.env

all: $(NAME)

$(NAME):
	ENV=$(NAME) ./srcs/requirements/tools/setup.sh
	docker compose -f $(SRC) up -d --build

stop:
	docker compose -f $(SRC) stop

down:
	docker compose -f $(SRC) down

ps:
	docker compose -f $(SRC) ps -a

logs:
	docker compose -f $(SRC) logs -f || true

clean:
	docker compose -f $(SRC) rm -f -a

fclean: stop clean
	docker system prune -a -f
	ENV=$(NAME) ./srcs/requirements/tools/cleanup.sh

re: fclean all
