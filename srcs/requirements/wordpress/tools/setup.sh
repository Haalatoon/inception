#!/bin/sh
set -e

DB_PASS=$(cat /run/secrets/db_password)
ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
USER_PASS=$(cat /run/secrets/wp_user_password)

until mysqladmin ping -h"$WP_DB_HOST" -u"$WP_DB_USER" -p"$DB_PASS" --silent 2>/dev/null; do
	sleep 2
done

cd /var/www/html

if [ ! -f wp-config.php ]; then
	wp core download --allow-root

	wp config create\
		--dbname="$WP_DB_NAME"\
		--dbuser="$WP_DB_USER"\
		--dbpass="$DB_PASS"\
		--dbhost="$WP_DB_HOST"\
		--allow-root

	wp core install\
		--url="$WP_URL"\
		--title="$WP_TITLE"\
		--admin_user="$WP_ADMIN_USER"\
		--admin_password="$ADMIN_PASS"\
		--admin_email="$WP_ADMIN_EMAIL"\
		--skip-email\
		--allow-root

	wp user create "$WP_USER" "$WP_USER_EMAIL"\
		--role=author\
		--user_pass="$USER_PASS"\
		--allow-root

	chown -R www-data:www-data /var/www/html
fi

exec php-fpm8.2 -F
