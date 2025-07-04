# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: joandre- <joandre-@student.42lisboa.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/02 02:45:08 by joandre-          #+#    #+#              #
#    Updated: 2025/07/04 02:31:34 by joandre-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

ENV = srcs/.env
NAME = inception

all: $(NAME)

$(NAME): $(ENV)
	docker compose -f srcs/compose.yml up -d --build

$(ENV):
	ENV=$(ENV) ./srcs/requirements/tools/setup.sh

clean:
	docker compose -f srcs/compose.yml rm -f -a

fclean:
	docker compose -f srcs/compose.yml stop
	docker system prune -a -f && ENV=$(ENV) ./srcs/requirements/tools/cleanup.sh

re: fclean all
