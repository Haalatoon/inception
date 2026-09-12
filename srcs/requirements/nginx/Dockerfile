FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends\
    nginx\
    openssl\
    && rm -rf /var/lib/apt/lists/*

ARG DOMAIN

RUN mkdir -p /etc/nginx/ssl\
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048\
    -keyout /etc/nginx/ssl/server.key\
    -out /etc/nginx/ssl/server.crt\
    -subj "/C=MA/ST=Casablanca/L=Casablanca/O=42/CN=${DOMAIN}"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
