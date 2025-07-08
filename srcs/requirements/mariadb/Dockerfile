ARG OS_VERSION=penultimate
FROM alpine:$OS_VERSION

RUN apk add --no-cache shadow mariadb
COPY ./tools/db-boot.sh /usr/local/bin/db-boot.sh

ENTRYPOINT [ "/usr/local/bin/db-boot.sh" ]
