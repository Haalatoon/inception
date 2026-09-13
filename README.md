*This project has been created as part of the 42 curriculum by hrhilane.*

# Inception

## Description

Inception is a System Administration project that consists of building a small
web infrastructure using Docker and Docker Compose inside a Virtual Machine.
The infrastructure is composed of three services, each running in its own
dedicated container, connected through a private Docker network:

- **NGINX** — serves as the only entry point, listening on port 443 with
  TLSv1.2/TLSv1.3 only. It reverse-proxies PHP requests to WordPress.
- **WordPress + php-fpm** — hosts the WordPress website and processes PHP
  requests. No web server runs inside this container.
- **MariaDB** — stores the WordPress database.

Two Docker named volumes provide persistent storage:

- One for the WordPress database (`/home/hrhilane/data/mariadb`).
- One for the WordPress website files (`/home/hrhilane/data/wordpress`).

The domain `hrhilane.42.fr` points to the local IP of the VM.

## Instructions

### Prerequisites

- A Virtual Machine (Debian 12 "bookworm" recommended).
- Docker Engine and the Docker Compose plugin installed inside the VM.
- Add the domain to `/etc/hosts`:

```
127.0.0.1    hrhilane.42.fr
```

### Secrets

Create the `secrets/` folder at the root of the repository and add the
following files (each containing a single password):

```
secrets/db_root_password.txt
secrets/db_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

These files are gitignored and must never be committed.

### Environment file

Copy `.env.example` to `.env` inside `srcs/` and adjust the values if needed:

```bash
cp srcs/.env.example srcs/.env
```

### Build and run

From the repository root:

```bash
make        # build and start all services
make down   # stop all services
make clean  # stop and remove containers, images, volumes
make fclean # clean + remove /home/hrhilane/data
make re     # full rebuild
```

### Access

- Website: `https://hrhilane.42.fr`
- Admin panel: `https://hrhilane.42.fr/wp-admin`

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress documentation](https://wordpress.org/documentation/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [WP-CLI reference](https://developer.wordpress.org/cli/commands/)

### AI Usage

AI was used to review the Dockerfiles, `docker-compose.yml`, and entrypoint
scripts for compliance with the Inception subject. It also helped diagnose
runtime errors (PHP-FPM socket mismatch, MariaDB initialization, WordPress
waiting loop). All AI-generated suggestions were reviewed, tested, and
understood before being applied.

## Project Design Choices

### Virtual Machines vs Docker

A Virtual Machine emulates full hardware and runs an entire operating system
with its own kernel. It is heavy (GBs of RAM, minutes to boot). Docker
containers share the host kernel and only package the application and its
dependencies, making them lightweight (MBs, seconds to start). Inception uses
Docker to isolate each service while sharing the host kernel.

### Docker Secrets vs Environment Variables

Environment variables are visible in `docker inspect`, logs, and process
listings. Docker Secrets are mounted as files inside the container (usually
under `/run/secrets/`) and are only accessible to the container that needs
them. This project uses secrets for all passwords and `.env` only for
non-sensitive configuration (domain name, database name, usernames).

### Docker Network vs Host Network

`network: host` removes isolation: the container uses the host's network
stack directly. A custom bridge network like `inception` gives each container
its own IP on an isolated subnet, allows DNS resolution between containers by
service name, and keeps services unreachable from the host unless explicitly
published. The subject forbids `host` networking, so a custom bridge network
is used.

### Docker Volumes vs Bind Mounts

Bind mounts link a host directory directly into a container; the host path
must exist and file ownership can be confusing. Docker named volumes are
managed by Docker, portable, and can be backed by a host path using the
`local` driver with `driver_opts` (which this project uses to satisfy the
`/home/hrhilane/data` requirement). Named volumes are the recommended
approach for persistent data, and the subject requires them for the database
and website files.