# User Documentation

## 1. Service Overview
This infrastructure provides a complete web hosting stack composed of three distinct services running in isolated containers:

* **NGINX:** The entry point for the website. It acts as a secure web server handling HTTPS traffic and forwarding requests to the application.
* **WordPress:** The Content Management System (CMS) where the website is built and managed.
* **MariaDB:** The database server that stores all the content and user data for the WordPress site.

## 2. Managing the Project
The project is controlled using a `Makefile` located at the root of the repository.

### Starting the Infrastructure
To download the images, build the containers, and start the services, open a terminal in the project root and run:
```bash
make
```

### Stopping the Infrastructure
To stop the containers and remove the network:
```bash
make down
```

### Cleaning Up
To stop the containers and delete all data (database and website files):
```bash
make fclean
```

## 3. Accessing the Services

### Website
Once the project is running, you can access the WordPress website at:
* **URL:** `https://rcreer.42.fr`
* **Note:** You must accept the self-signed certificate warning in your browser.

### Admin Panel
To manage the WordPress site:
* **URL:** `https://rcreer.42.fr/wp-admin`
* **Login:** Use the administrator credentials defined in your `.env` file (see below).

## 4. Managing Credentials
All sensitive information, including usernames, passwords, and domain names, is managed via environment variables.

* **Location:** `srcs/.env`
* **How to Change:** Edit this file before starting the project to update credentials.
* **Important Variables:**
    * `WP_ADMIN_USER` / `WP_ADMIN_PASS`: Administrator login for WordPress.
    * `WP_USER` / `WP_PASS`: Standard user login for WordPress.
    * `DB_USER` / `DB_PASS`: Database credentials.

## 5. Checking Service Status
To verify that all services are running correctly:

1.  **List running containers:**
    ```bash
    docker compose -f srcs/docker-compose.yml ps
    ```
    *Expectation:* You should see three containers (`nginx`, `wordpress`, `mariadb`) with status `Up`.

2.  **Check logs:**
    If a service is not working, check its logs:
    ```bash
    docker compose -f srcs/docker-compose.yml logs [service_name]
    # Example: docker compose -f srcs/docker-compose.yml logs nginx
    ```