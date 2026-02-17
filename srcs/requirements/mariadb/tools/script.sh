#!/bin/bash

# Ensure the script fails on error to avoid partial initialization
set -e

# Configuration
# Only append config if not present to avoid duplication on restart
if ! grep -q "bind-address=0.0.0.0" "$DB_CONF_ROUTE"; then
    echo "" >> "$DB_CONF_ROUTE"
    echo "[mysqld]" >> "$DB_CONF_ROUTE"
    echo "bind-address=0.0.0.0" >> "$DB_CONF_ROUTE"
fi

# Initialize MariaDB data directory if it doesn't exist
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --datadir=$DB_INSTALL > /dev/null

    # Start MariaDB temporarily in the background to set up users/tables
    # We use mysqld_safe because it handles some environment setup, but we'll kill it later.
    mysqld_safe --datadir=$DB_INSTALL &
    pid=$!

    echo "Waiting for MariaDB to start..."
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    echo "Configuring Database..."
    # Execute setup commands
    # 1. Create Database if not exists
    # 2. Create User if not exists
    # 3. Grant privileges
    # 4. Flush privileges
    # 5. Secure root user (set password)
    
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`$DB_USER\`@'%' IDENTIFIED BY '$DB_PASS';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO \`$DB_USER\`@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"
    
    # Update root password last
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"

    echo "Shutting down temporary MariaDB instance..."
    # Shutdown using the new root password
    mysqladmin -u root -p"$DB_ROOT_PASS" shutdown

    # Wait for the background process to finish properly
    wait $pid
    echo "Initialization complete."
else
    echo "MariaDB already initialized. Skipping setup."
fi

# Start MariaDB in the foreground
# The 'exec' command replaces the shell process with mysqld_safe, 
# ensuring it becomes PID 1 (or the direct child of Docker runtime) 
# and handles signals correctly.
echo "Starting MariaDB..."
exec mysqld_safe --datadir=$DB_INSTALL