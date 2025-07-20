ARG OS_VERSION=penultimate
FROM alpine:$OS_VERSION

RUN apk add --no-cache mariadb \
  && sed -i 's/skip-networking/# skip-networking/' /etc/my.cnf.d/mariadb-server.cnf \
  && sed -i 's/#bind-address/bind-address/' /etc/my.cnf.d/mariadb-server.cnf
COPY ./tools/db-boot.sh /usr/local/bin/db-boot.sh

ENTRYPOINT [ "/usr/local/bin/db-boot.sh" ]
