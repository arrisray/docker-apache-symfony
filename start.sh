#!/bin/bash

chown -R www-data: /var/www/askeet
chmod -R a+rX /var/www/askeet

source /etc/apache2/envvars
apache2 -D FOREGROUND &

# MySQL
if [ ! -f /var/lib/mysql/ibdata1 ]; then
    mysql_install_db

    /usr/bin/mysqld_safe &
    sleep 10s

    echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'changeme' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

    killall mysqld
    sleep 10s
fi

/usr/bin/mysqld_safe &

