FROM frapsoft/openssl as ssl

WORKDIR /app

COPY . /app

RUN ls -la

RUN openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 -keyout /app/ssl/private/selfsigned.key \
        -out /app/ssl/certs/selfsigned.crt \
        -subj "/C=br/ST=br/L=br/O=br/OU=docker/CN=localhost.teste"

FROM nginx:latest

RUN ls -la

COPY ./nginx/ /etc/nginx/conf.d/
COPY ./site /var/www/html

# support running as arbitrary user which belogs to the root group
# RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# RUN chgrp -R root /var/cache/nginx

# comment user directive as master process is run as user in OpenShift anyhow
# RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
#
COPY --from=ssl /app/ssl /etc/ssl/

# RUN chmod -R 777 /var/www/html/storage

# EXPOSE 8081

# RUN addgroup nginx root

# USER nginx

ENTRYPOINT ["nginx","-g","daemon off;"]
