FROM debian:squeeze
MAINTAINER Arris Ray <arris.ray@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN    apt-get update \
    && apt-get -yq install \
        libapache2-mod-php5 \
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
RUN chown -R www-data:www-data /usr/share/php/data

# Configure Apache vhost
RUN rm -rf /var/www/*
RUN a2enmod rewrite
RUN a2enmod php5
ADD vhost.conf /etc/apache2/other/askeet.conf

# Add main start script for when image launches
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

# Install Symfony
RUN pear upgrade -f PEAR
RUN pear channel-discover pear.symfony-project.com
RUN pear install symfony/symfony-1.0.0

# Setup shared volume for application code
# See: https://github.com/boot2docker/boot2docker/issues/581#issuecomment-114804894 
ADD . /var/www/askeet
RUN usermod -u 1000 www-data 
RUN usermod -G staff www-data

EXPOSE 80
CMD ["/start.sh"]
