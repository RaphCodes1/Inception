FROM debian:bullseye

RUN apt update && apt install -y \
    mariadb-server \
    mariadb-client

COPY ./requirements/mariadb/tools/script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh
ENTRYPOINT ["/usr/local/bin/script.sh"]