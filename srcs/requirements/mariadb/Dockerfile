FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends\
    mariadb-server\
    mariadb-client\
    && rm -rf /var/lib/apt/lists/*\
    && mkdir -p /run/mysqld\
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["setup.sh"]
