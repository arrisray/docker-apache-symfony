FROM debian:jessie
MAINTAINER Arris Ray <arris.ray@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN    apt-get update \
    && apt-get -yq install \
        apache2 \
        libapache2-mod-php5 \
        php5 \
        php5-intl \
        php5-curl \
        php5-mysql \
        php-pear \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP (CLI and Apache)
RUN sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php5/cli/php.ini \
    && sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php5/apache2/php.ini
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini

# Configure Apache
RUN sed -i "N;$!/Global configuration\n#/a ServerName localhost" /etc/apache2/apache2.conf

# Configure Apache vhost
RUN rm -rf /var/www/*
RUN a2enmod rewrite
RUN a2enmod php5
ADD vhost.conf /etc/apache2/sites-available/000-default.conf

# Add main start script for when image launches
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

# Install Symfony
RUN pear upgrade PEAR
RUN pear channel-discover pear.symfony-project.com
RUN pear install symfony/symfony

# Setup shared volume for application code
# See: https://github.com/boot2docker/boot2docker/issues/581#issuecomment-114804894 
ADD . /var/www/main
RUN usermod -u 1000 www-data 
RUN usermod -G staff www-data

EXPOSE 80
CMD ["/start.sh"]
