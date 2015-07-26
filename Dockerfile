FROM debian:jessie
MAINTAINER Arris Ray <arris.ray@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN    apt-get update \
    && apt-get -yq install \
        libapache2-mod-php5 \
        php5-intl \
        php5-curl \
        php-pear \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP (CLI and Apache)
RUN sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php5/cli/php.ini \
    && sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php5/apache2/php.ini

# Configure Apache vhost
RUN rm -rf /var/www/*
RUN a2enmod rewrite
ADD vhost.conf /etc/apache2/sites-available/000-default.conf

# Add main start script for when image launches
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

# Install Symfony
RUN pear upgrade PEAR
RUN pear channel-discover pear.symfony-project.com
RUN pear install symfony/symfony

# Setup shared volume for application code
Add . /var/www/main

EXPOSE 80
CMD ["/start.sh"]
