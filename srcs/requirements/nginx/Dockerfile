FROM debian:bullseye

RUN apt-get update && apt install -y nginx && apt upgrade -y openssl

COPY ./requirements/nginx/tools/conf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/conf.sh

ENTRYPOINT ["conf.sh"]
