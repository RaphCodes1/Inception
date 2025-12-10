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