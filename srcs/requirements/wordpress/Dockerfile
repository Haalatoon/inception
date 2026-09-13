FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends\
    default-mysql-client\
    php-mysql\
    php-cgi\
    php-fpm\
    libcurl4\
    curl\
    php-curl\
    php-dom\
    imagemagick\
    php-imagick\
    php-intl\
    php-mbstring\
    ca-certificates\
    openssl\
    php-xml\
    libzip4\
    php-zip\
    bc\
    php-bcmath\
    php-iconv\
    php-shmop\
    php-simplexml\
    php-xmlreader\
    ghostscript\
    && rm -rf /var/lib/apt/lists/*\
    && mkdir -p /run/php\
    && sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar\
    && chmod +x wp-cli.phar\
    && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

ENTRYPOINT ["setup.sh"]

