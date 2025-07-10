ARG OS_VERSION=penultimate
FROM alpine:$OS_VERSION

RUN apk add --no-cache wget php php-fpm \
  php-phar php-json php-curl php-mysqli php-mbstring \
  && ln -sf /usr/sbin/$(ls /usr/sbin | grep php-fpm) /usr/sbin/php-fpm \
  && sed -i 's/listen = 127.0.0.1:/listen = /g' /etc/php*/php-fpm.d/www.conf \
  && sed -i 's|memory_limit = 128M|memory_limit = 256M|g' /etc/php83/php.ini \
  && wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp-cli

WORKDIR /var/www/html
RUN apk del wget
COPY ./tools/wp-config.sh /usr/local/bin/wp-config.sh

ENTRYPOINT [ "/usr/local/bin/wp-config.sh" ]
