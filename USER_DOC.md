# User Documentation

## Services Provided

The Inception stack provides:

- A WordPress website served over HTTPS at `https://hrhilane.42.fr`.
- A WordPress administration panel.
- A MariaDB database storing all WordPress content.
- Persistent storage for both the database and the website files.

## Starting and Stopping the Project

From the repository root:

```bash
make        # build and start all services
make down   # stop all services without removing data
make re     # full rebuild (removes data)
```

Check that everything is running:

```bash
docker compose -f srcs/docker-compose.yml ps
```

All three containers (`mariadb`, `wordpress`, `nginx`) must show `Up`.

## Accessing the Website

Open a browser and go to:

```
https://hrhilane.42.fr
```

The self-signed certificate will trigger a warning — accept it.

## Accessing the Administration Panel

1. Go to `https://hrhilane.42.fr/wp-admin`.
2. Log in with the administrator account:
   - Username: `supervisor`
   - Password: contents of `secrets/wp_admin_password.txt`
3. A second account exists for content authoring:
   - Username: `editor`
   - Password: contents of `secrets/wp_user_password.txt`

## Managing Credentials

All passwords are stored as Docker secrets in the `secrets/` folder:

| File | Purpose |
|------|---------|
| `secrets/db_root_password.txt` | MariaDB root password |
| `secrets/db_password.txt` | MariaDB WordPress user password |
| `secrets/wp_admin_password.txt` | WordPress administrator password |
| `secrets/wp_user_password.txt` | WordPress author password |

These files are gitignored. To rotate a password, edit the file and rebuild
with `make re`.

## Checking That Services Are Running

List containers:

```bash
docker compose -f srcs/docker-compose.yml ps
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

Verify the database is reachable:

```bash
docker exec -it mariadb mariadb -u wpuser -p
```

Enter the password from `secrets/db_password.txt`, then run:

```sql
USE wordpress;
SHOW TABLES;
```

Expected: 12 WordPress tables.