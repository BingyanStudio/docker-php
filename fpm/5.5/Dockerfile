FROM bingyan/php:5.5.35

ENV PHP_FPM_VERSION 5.5.35

RUN apk update && \
    apk add 'php-fpm<5.5.36' && \
    mkdir -p /etc/php/fpm.d && \
    rm -rf /var/cache/apk/*

COPY ./php-fpm.conf /etc/php/

EXPOSE 9000
WORKDIR /var/www

CMD ["php-fpm"]
