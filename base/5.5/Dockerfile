FROM alpine:3.3

ENV PHP_VERSION 5.5.35

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.0/main" > /etc/apk/repositories && \
    # add basic packages
    apk update && \
    apk add 'php<5.5.36' 'php-cli<5.5.36' php-json php-openssl php-phar php-zlib php-dom \
            php-zip php-ctype php-curl php-xml php-gd php-mcrypt \
            php-mysql php-mysqli php-pdo_mysql php-pgsql php-pdo_pgsql \
            php-sqlite3 php-pdo_sqlite && \
    mkdir -p /var/www && \
    # build redis extension
    apk add 'php-dev<5.6' && \
    # add newer build tools from alpine 3.3 repo
    buildDeps='autoconf automake make libtool re2c bison gcc g++ alpine-sdk git' && \
    apk add 'musl>1.1.6' $buildDeps --no-cache -X 'http://dl-cdn.alpinelinux.org/alpine/v3.3/main' && \
    cd /tmp && \
      git clone https://github.com/phpredis/phpredis && \
      cd phpredis && \
        phpize && ./configure && make && make install && \
        echo 'extension=redis.so' > /etc/php/conf.d/redis.ini && \
      cd /tmp && rm -rf /tmp/phpredis && \
    # build mongodb extension(require musl>=1.1.7)
    apk add openssl-dev pcre-dev && \
    cd /tmp && \
       git clone https://github.com/mongodb/mongo-php-driver.git && \
       cd mongo-php-driver && \
          git checkout 1.1.6 && \
          git submodule sync && git submodule update --init && \
          phpize && \
          ./configure && \
          make all -j 5 && make install && \
          echo 'extension=mongodb.so' > /etc/php/conf.d/mongodb.ini && \
       cd /tmp && rm -rf /tmp/mongo-php-driver && \
    apk del openssl-dev pcre-dev && \
    # clean packages
    apk del $buildDeps php-dev && \
    rm -rf /var/cache/apk/*

ENV PUBLIC_BIN /public_bin
ENV PATH $PUBLIC_BIN:$PATH

ADD ./utils/install.sh /usr/local/bin/install

WORKDIR /var/www

CMD ["php", "-a"]
