*This project has been created as part of the 42 curriculum by rcreer.*

# Inception

## Description 
This project aims to broaden knowledge of system administration by using Docker. 
The goal is to virtualize several Docker images, creating a small infrastructure composed of different services under specific rules. 
The project requires setting up a multi-service architecture including NGINX, WordPress, and MariaDB, each running in dedicated containers.

## Instructions

### Prerequisites
* Docker & Docker Compose installed on the machine.
* Make.

### Installation & Execution
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/RaphCodes1/Inception.git
    cd Inception 
    ```

2.  **Environment Configuration:**
    Create a `.env` file in `srcs/` containing the required environment variables (see `srcs/.env.example` or project documentation for the list of variables). 

3.  **Domain Configuration:**
    Open your host's `/etc/hosts` file and add the following line to redirect the domain to your local IP:
    ```
    127.0.0.1   rcreer.42.fr
    ```

4.  **Run the Project:**
    Execute the Makefile from the root directory to build and start the containers:
    ```bash
    make
    ```
    This command will build the Docker images and start the network using `docker-compose.yml`.

5.  **Stop the Project:**
    ```bash
    make down
    ```

## Project Description & Design Choices

### Docker Implementation 
This project utilizes a `docker-compose.yml` file located in the `srcs` folder to orchestrate the services. Custom Dockerfiles were written for NGINX, WordPress, and MariaDB based on Alpine/Debian penultimates stable versions.

### Comparisons

#### Virtual Machines vs Docker
* **Virtual Machines (VMs):** Emulate a complete hardware system, including a full OS kernel. They provide strong isolation but are resource-heavy and slow to boot.
* **Docker:** Uses containerization to share the host system's kernel. Containers are lightweight, start almost instantly, and package the application with its dependencies, ensuring consistency across environments.

#### Secrets vs Environment Variables
* **Environment Variables:** Useful for non-sensitive configuration (e.g., paths, domain names). However, they can be inspected via `docker inspect`, making them less secure for credentials.
* **Secrets:** Docker Secrets are encrypted during transit and stored in a TMPFS within the container. They are intended for sensitive data like passwords and API keys, preventing accidental exposure in logs or git history.

#### Docker Network vs Host Network
* **Host Network:** The container shares the host's networking namespace. It uses the host's IP and ports directly, offering no network isolation.
* **Docker Network:** Creates a virtual bridge network (used in this project). Containers can communicate with each other via service names (DNS) while being isolated from the outside world, exposing only specific ports (e.g., 443).

#### Docker Volumes vs Bind Mounts
* **Bind Mounts:** A file or directory on the host machine is mounted into a container. The user manages the file location (e.g., `/home/[login]/data` in this project).
* **Docker Volumes:** Managed completely by Docker (usually in `/var/lib/docker/volumes`). They are easier to back up and migrate but harder to access directly from the host file system compared to bind mounts.

## Resources

### References
* [Docker Documentation](https://docs.docker.com/)
* [Docker Compose Documentation](https://docs.docker.com/compose/)
* [NGINX Documentation](https://nginx.org/en/docs/)
* [WordPress Codex](https://codex.wordpress.org/)
* [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

### AI Usage
* **Concept Explanation:** AI was used to explain the difference between TLSv1.2 and TLSv1.3 configurations in NGINX.
* **Script Debugging:** Used AI to troubleshoot syntax errors in the bash script used for the WordPress entrypoint.
* **Documentation:** AI assisted in structuring this README file to ensure all mandatory sections were covered.

## Project Description

### Virtual Machines vs Docker
* **Virtual Machines (VMs):** Emulate a complete hardware system, including a full OS kernel. They provide strong isolation but are resource-heavy and slow to boot.
* **Docker:** Uses containerization to share the host system's kernel. Containers are lightweight, start almost instantly, and package the application with its dependencies, ensuring consistency across environments.

### Secrets vs Environment Variables
* **Environment Variables:** Useful for non-sensitive configuration (e.g., paths, domain names). However, they can be inspected via `docker inspect`, making them less secure for credentials.
* **Secrets:** Docker Secrets are encrypted during transit and stored in a TMPFS within the container. They are intended for sensitive data like passwords and API keys, preventing accidental exposure in logs or git history.

### Docker Network vs Host Network
* **Host Network:** The container shares the host's networking namespace. It uses the host's IP and ports directly, offering no network isolation.
* **Docker Network:** Creates a virtual bridge network (used in this project). Containers can communicate with each other via service names (DNS) while being isolated from the outside world, exposing only specific ports (e.g., 443).

### Docker Volumes vs Bind Mounts
* **Bind Mounts:** A file or directory on the host machine is mounted into a container. The user manages the file location (e.g., `/home/[login]/data` in this project).
* **Docker Volumes:** Managed completely by Docker (usually in `/var/lib/docker/volumes`). They are easier to back up and migrate but harder to access directly from the host file system compared to bind mounts.