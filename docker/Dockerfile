FROM ubuntu:18.04

ENV \
ES_DB="127.0.0.1" \
ES_PORT="9200" \
DB_NAME="kibble" \
MAILHOST="127.0.0.1:25" \
SHARDS="5" \
REPLICA="1" \
ES_DB_PORT="http://127.0.0.1:9200"

RUN   apt-get update && \
      apt-get install -y \
      git \
      apache2 \
      python3 \
      python3-pip \
      gunicorn3 \
      curl

RUN git clone https://github.com/ArtyMandy/kibble.git /var/www/kibble

COPY ./docker-entrypoint.sh /

WORKDIR /var/www/kibble/setup

RUN pip3 install -r requirements.txt

EXPOSE 80
EXPOSE 8000
RUN a2enmod proxy_http

RUN echo "<VirtualHost *:80>\n\
   # Set this to your domain, or add kibble.localhost to /etc/hosts \n\
   ServerName kibble.localhost \n\
   DocumentRoot /var/www/kibble/ui/ \n\
   # Proxy to gunicorn for /api/ below: \n\
   ProxyPass /api/ http://localhost:8000/api/\n\
</VirtualHost> " > /etc/apache2/sites-available/000-default.conf

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT /docker-entrypoint.sh ${ES_DB_PORT}
