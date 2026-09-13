# Developer Documentation

## Repository Layout

```
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/                  # gitignored
│   ├── db_root_password.txt
│   ├── db_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env                  # gitignored, real values
    ├── .env.example
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/setup.sh
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/nginx.conf
        └── wordpress/
            ├── Dockerfile
            └── tools/setup.sh
```

## Setting Up the Environment from Scratch

1. Install a Debian 12 VM and the Docker Engine + Compose plugin.
2. Clone the repository:

   ```bash
   git clone <repo-url>
   cd inception
   ```

3. Create the secrets files (as described in `USER_DOC.md`).
4. Copy `.env.example` to `.env` and adjust for your login:

   ```bash
   cp srcs/.env.example srcs/.env
   nano srcs/.env
   ```

5. Add the domain to `/etc/hosts`:

   ```
   127.0.0.1    hrhilane.42.fr
   ```

## Building and Launching

From the repository root:

```bash
make re
```

This runs `docker compose -f srcs/docker-compose.yml up -d --build`.

## Managing Containers and Volumes

```bash
# Status
docker compose -f srcs/docker-compose.yml ps

# Logs
docker compose -f srcs/docker-compose.yml logs -f

# Stop
docker compose -f srcs/docker-compose.yml down

# Enter a container
docker exec -it mariadb sh
docker exec -it wordpress sh
docker exec -it nginx sh

# List volumes
docker volume ls
docker volume inspect mariadb
docker volume inspect wordpress
```

## Where Data Is Stored

Persistent data lives on the host in:

- `/home/hrhilane/data/mariadb` — MariaDB data files
- `/home/hrhilane/data/wordpress` — WordPress website files

These directories are bind-mounted through Docker named volumes so that data
survives container restarts and VM reboots.

## Data Persistence

Because both storage locations are Docker named volumes backed by host
directories, data persists across:

- `docker compose down`
- Container recreation
- VM reboots

Only `make fclean` (which removes `/home/hrhilane/data`) erases the data.

## Debugging

Check NGINX → PHP-FPM connectivity:

```bash
docker exec -it wordpress sh
grep ^listen /etc/php/8.2/fpm/pool.d/www.conf
```

Check WordPress installation state:

```bash
docker exec -it wordpress sh
wp core is-installed --allow-root && echo OK
wp user list --allow-root
```

Check MariaDB users:

```bash
docker exec -it mariadb mariadb -u root -p
```