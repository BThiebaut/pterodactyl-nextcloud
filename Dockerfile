FROM nextcloud:latest

# Move Nextcloud to Pterodactyl directory
RUN mkdir -p /home/container && \
    mv /var/www/html /home/container/html && \
    ln -s /home/container/html /var/www/html

# Create ptero group & add Apache
RUN groupadd -g 988 pterogroup && \
    usermod -aG pterogroup www-data

# Fix file permissions for Pterodactyl runtime user
RUN chown -R 988:988 /home/container/html && \
    chmod -R g+rwX /home/container/html

# Create writable apache run directory
RUN mkdir -p /home/container/apache-run && \
    chown -R 988:988 /home/container/apache-run

# Override Apache PIDFile and mutex dirs
RUN echo "PidFile /home/container/apache-run/apache2.pid" > /etc/apache2/conf-available/pteropid.conf && \
    echo "Mutex file:/home/container/apache-run/" >> /etc/apache2/conf-available/pteropid.conf && \
    a2enconf pteropid


WORKDIR /home/container

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]