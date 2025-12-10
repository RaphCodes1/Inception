#!/usr/bin/env bash

mkdir -p $CERT_DIR

openssl req -x509 -newkey rsa:2048 -days 365 -nodes -keyout $CERT_KEY -out $CERT -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=$HOST_LOGIN/UID=$USER"

chmod 644 $CERT_KEY
chmod 644 $CERT

# Create nginx config
cat > $NGINX_CONF << EOF
server {
    listen 443 ssl;
    server_name $HOST_LOGIN;

    root $WP_ROUTE;
    index index.php index.html;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_certificate $CERT;
    ssl_certificate_key $CERT_KEY;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass wordpress:9000;
    }
}
EOF

nginx -g "daemon off;"