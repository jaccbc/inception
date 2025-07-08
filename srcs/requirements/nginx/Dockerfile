ARG OS_VERSION=penultimate
FROM alpine:$OS_VERSION

RUN apk add --no-cache nginx \
  && mkdir -p /run/nginx /var/www/html \
  && chown -R nginx:nginx /run/nginx /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT [ "/usr/sbin/nginx" ]
CMD [ "-g", "daemon off;" ]
