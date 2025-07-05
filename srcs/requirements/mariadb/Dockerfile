ARG OS_VERSION=penultimate
FROM alpine:$OS_VERSION

RUN apk add --no-cache mariadb \
  && mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld \
  && chown -R mysql:mysql /var/lib/mysql \
  && mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql \
  && rm -rf /usr/share/doc /tmp/*
COPY ./tools/db-boot.sh /usr/local/bin/db-boot.sh

ENTRYPOINT [ "/usr/local/bin/db-boot.sh" ]
