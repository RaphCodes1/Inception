#!/bin/bash

# 1. PRE-FLIGHT: Fix PHP Listening Port (Debian Specific)
# 42 Rule: NGINX needs to talk to PHP on port 9000, not a socket file.
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# 2. WAIT FOR DATABASE (Crucial Fix for "Connection Refused")
echo "Waiting for MariaDB..."
while ! mariadb -h$DB_HOST -u$DB_USER -p$DB_PASS -e "SELECT 1;" > /dev/null 2>&1; do
    sleep 2
done
echo "MariaDB is reachable!"

# 3. WORDPRESS SETUP
mkdir -p $WP_ROUTE
cd $WP_ROUTE

if [ ! -f "wp-config.php" ]; then
    echo "Configuring WordPress..."
    
    # Download WP-CLI if missing
    if [ ! -f "/usr/local/bin/wp" ]; then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    # Download Core Files
    wp core download --allow-root

    # Create Config
    wp config create \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASS \
        --dbhost=$DB_HOST \
        --allow-root

    # Install Site
    wp core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASS \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    # Create Second User
    wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASS --allow-root
    
    # --- [NEW] ENABLE COMMENTS AUTOMATICALLY ---
    # Enable comments in global settings
    wp option update default_comment_status open --allow-root
    # Open comments on the Sample Page (ID 2)
    wp post update 2 --comment_status=open --allow-root
    # -------------------------------------------
    
else
    echo "WordPress is already configured."
fi

# 4. DEBIAN FIX: Create PHP run directory
if [ ! -d "/run/php" ]; then
    mkdir -p /run/php
fi

# 5. START SERVICE
exec /usr/sbin/php-fpm7.4 -F