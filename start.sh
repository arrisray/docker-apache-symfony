#!/bin/bash

chown -R www-data: /var/www/askeet
chmod -R a+rX /var/www/askeet

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
exec /etc/init.d/mysql start
