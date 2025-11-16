FROM nextcloud:fpm

# Install nginx + supervisor
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Create container working directory
RUN mkdir -p /home/container
WORKDIR /home/container

# Move nextcloud files into /home/container/html
RUN mv /var/www/html /home/container/html && \
    ln -s /home/container/html /var/www/html


# Pterodactyl runs container as UID 988
RUN chown -R 988:988 /home/container/html


RUN rm -f /etc/nginx/sites-enabled/default

# Nextcloud Nginx configuration
RUN mkdir -p /etc/nginx/sites-enabled

COPY nginx.conf /etc/nginx/sites-enabled/nextcloud.conf

COPY supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 9000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]