FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf \
&& mkdir -p /etc/nginx/certs/

COPY azure.nginx.conf /etc/nginx/nginx.conf

RUN apt-get update && apt-get install -y --no-install-recommends nano apache2-utils && rm -rf /var/lib/apt/lists/* 

COPY start.sh /

CMD ["/start.sh"]
