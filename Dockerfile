FROM nextcloud:latest

# Home container
RUN mkdir -p /home/container

# Link for nextcloud/pterodactyl behavior
RUN mv /var/www/html /home/container/html && \
    ln -s /home/container/html /var/www/html

# group for ptero and apache
RUN groupadd -g 988 pterogroup && \
    usermod -aG pterogroup www-data

# UUID 988 should be pterodactyl usable group
RUN chown -R 988:988 /home/container/html && \
    chmod -R g+rwX /home/container/html

# Working directory for Pterodactyl
WORKDIR /home/container

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
