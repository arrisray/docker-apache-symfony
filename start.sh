#!/bin/bash

chown -R www-data: /var/www/askeet
chmod -R a+rX /var/www/askeet

chown -R www-data: /usr/share/php/data
chmod -R a+rX /usr/share/php/data

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
