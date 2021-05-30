FROM bitnami/php-fpm:7.4

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

RUN apt-get update && \
    apt-get install -y nginx cron && \
    rm -rf /var/lib/apt/lists/*
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN mkdir -p /opt/confd/bin && \
    curl -s -L https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 -o /opt/confd/bin/confd && \
    chmod +x /opt/confd/bin/confd

RUN mkdir -p /assets/install && \
    cd /assets/install && \
    curl -ssL https://github.com/osTicket/osTicket/archive/v1.15.2.tar.gz | tar xvfz - --strip 1 -C /assets/install && \
    chmod -R a+rX /assets/install/ && \
    chmod -R u+rw /assets/install/ && \
    mv /assets/install/* /app && \
    rm -rf /app/setup

COPY ./rootfs /

RUN s6-rmrf /etc/s6/services/s6-fdholderd/down

EXPOSE 80

ENTRYPOINT ["/init"]
