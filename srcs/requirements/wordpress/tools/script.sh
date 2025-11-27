#!/usr/bin/env bash 
mkdir -p $WP_ROUTE

cd $WP_ROUTE

if [ ! -f "wp-config.php" ]; then
    echo "WordPress is not configured. Installing..."
    
    # Download
    wp core download --force --allow-root

    # Create Config
    wp config create \
        --path=$WP_ROUTE \
        --allow-root \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASS \
        --dbhost=$DB_HOST \
        --dbprefix=wp_

    # Install WordPress
    wp core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASS \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    # Create User
    wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASS --allow-root
else
    echo "WordPress is already configured. Skipping setup."
fi

# 3. Always fix permissions (just in case)
chown -R www-data:www-data $WP_ROUTE

# 4. Start PHP
php-fpm7.4 -F