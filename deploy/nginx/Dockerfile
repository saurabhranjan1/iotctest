FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf  \
&& mkdir -p /etc/nginx/certs/

COPY nginx.conf /etc/nginx/

# COPY dev.localhost.crt /etc/nginx/certs/
# COPY dev.localhost.key /etc/nginx/certs/

RUN apt-get update && apt-get install -y --no-install-recommends nano apache2-utils && rm -rf /var/lib/apt/lists/* 


COPY start.sh /
RUN chmod +x /start.sh
CMD ["/start.sh"]
