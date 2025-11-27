#! /usr/bin/env bash

echo >> $DB_CONF_ROUTE
echo "[mysqld]" >> $DB_CONF_ROUTE
echo "bind-address=0.0.0.0" >> $DB_CONF_ROUTE

mysql_install_db --datadir=$DB_INSTALL

mysqld_safe & 

mysql_pid=$!


until mysqladmin ping >/dev/null 2>&1; do
    echo -n "."; sleep 0.2
done


mysql -u root -e "CREATE DATABASE $DB_NAME;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
    GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
    FLUSH PRIVILEGES;"


wait $mysql_pid


# #!/bin/bash

# # 1. Fix the Configuration (Idempotent Check)
# # Only add the bind-address if it is NOT already in the file
# if ! grep -q "bind-address=0.0.0.0" "$DB_CONF_ROUTE"; then
#     echo "[mysqld]" >> "$DB_CONF_ROUTE"
#     echo "bind-address=0.0.0.0" >> "$DB_CONF_ROUTE"
# fi

# # 2. Check if the database is already installed
# # We check if the 'mysql' folder exists inside your data directory
# if [ ! -d "$DB_INSTALL/mysql" ]; then
#     echo "Database not found. Installing..."

#     # A. Initialize the database files
#     # Added --user=mysql to ensure permissions are correct
#     mysql_install_db --user=mysql --datadir=$DB_INSTALL

#     # B. Start a temporary server in the background
#     mysqld_safe --datadir=$DB_INSTALL &
#     temp_pid=$!

#     # C. Wait for the server to be ready
#     until mysqladmin ping >/dev/null 2>&1; do
#         echo -n "."; sleep 1
#     done

#     # D. Run the setup SQL commands
#     # We use 'CREATE USER IF NOT EXISTS' to be safe
#     mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;
#     ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
#     CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
#     GRANT ALL ON $DB_NAME.* TO '$DB_USER'@'%';
#     FLUSH PRIVILEGES;"

#     # E. Stop the temporary server properly
#     mysqladmin -u root -p$DB_ROOT_PASS shutdown
#     wait $temp_pid
    
#     echo "Database setup complete."
# else
#     echo "Database already exists. Skipping setup."
# fi

# # 3. Start the final server
# # 'exec' ensures this process becomes PID 1, which is required for Docker signals
# exec mysqld_safe --datadir=$DB_INSTALL