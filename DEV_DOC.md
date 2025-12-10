# Developer Documentation

## 1. Environment Setup
To set up the development environment from scratch, you need to configure the host machine and the environment variables.

### Prerequisites
* **OS:** Linux VM (or compatible environment).
* **Tools:** Docker Engine, Docker Compose, GNU Make.
* **Network:** Port 443 must be available.

### Host Configuration
Map the domain to the local loopback address in your `/etc/hosts` file:
127.0.0.1 rcreer.42.fr

### Environment Variables (.env)
The project relies entirely on a single `.env` file located in `./srcs/.env` for configuration and credentials.

**Required Variables:**
Create the file `./srcs/.env` and ensure the following variables are defined:

* **Host Configuration:**
    * `HOST_NAME` (e.g., localhost)
    * `HOST_LOGIN` (e.g., login.42.fr)

* **WordPress Configuration:**
    * `WP_ROUTE` (Path in container, usually /var/www/html/wordpress)
    * `WP_URL` (Domain URL)
    * `WP_ADMIN_USER` & `WP_ADMIN_PASS` & `WP_ADMIN_EMAIL` (Admin credentials)
    * `WP_USER` & `WP_PASS` & `WP_EMAIL` (Standard user credentials)

* **Database Configuration:**
    * `DB_NAME` (Database name)
    * `DB_USER` & `DB_PASS` (Database standard user credentials)
    * `DB_ROOT_PASS` (Root password)
    * `DB_HOST` (Service name, e.g., mariadb)
    * `DB_INSTALL` (Data directory in container)

* **Nginx/Certificates:**
    * `CERT` & `CERT_KEY` (Paths to SSL certificates)

* **Security Note:** This file contains cleartext passwords. Ensure it is listed in `.gitignore` and never committed to the repository.

## 2. Building and Launching
The project uses a `Makefile` to orchestrate `docker-compose`.

* **Build & Run:**
    ```bash
    make
    ```
    *This creates the necessary data directories on the host, builds the images from the Dockerfiles in `srcs/requirements/`, and starts the network.*

* **Rebuild specific services:**
    If you modify a Dockerfile (e.g., NGINX) or the `.env` file, force a rebuild:
    ```bash
    docker compose -f ./srcs/docker-compose.yml up -d --build nginx
    ```

## 3. Container Management
Use the following commands to manage the infrastructure during development.

### Service Status
Check the status of the containers (ensure all are `Up`):
```bash
docker compose -f ./srcs/docker-compose.yml ps

Logging:
View logs for debugging:

Bash

docker compose -f ./srcs/docker-compose.yml logs nginx
docker compose -f ./srcs/docker-compose.yml logs mariadb
docker compose -f ./srcs/docker-compose.yml logs wordpress

Accessing Containers:
To open an interactive shell inside a running container:

Bash

docker exec -it [container_name] /bin/bash
# Example: docker exec -it wordpress /bin/bash

Data Persistence & Storage
The project uses Docker volumes mapped to specific directories on the host machine to ensure data persists even if containers are destroyed.

Host Directory Structure
Data is stored in the user's home directory:

Database Data: /home/[YOUR_LOGIN]/data/mariadb

WordPress Files: /home/[YOUR_LOGIN]/data/wordpress

Volume Mapping
MariaDB: The host folder /home/[YOUR_LOGIN]/data/mariadb is mounted to /var/lib/mysql inside the database container.

WordPress: The host folder /home/[YOUR_LOGIN]/data/wordpress is mounted to /var/www/html inside the WordPress container.

Note: Running make down does not delete this data. Running make fclean will delete these folders and reset the database/website.