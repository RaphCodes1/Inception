FROM debian:bullseye

RUN apt-get update && apt install nginx openssl -y 
RUN mkdir -p /etc/nginx/ssl

COPY ./requirements/nginx/tools/conf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/conf.sh

ENTRYPOINT ["conf.sh"]
