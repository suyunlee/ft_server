#!/bin/bash

# ssl
openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Lee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.crt etc/ssl/certs/
mv localhost.dev.key etc/ssl/private/
chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

# nginx 설정
cp -rp /tmp/default /etc/nginx/sites-available/

# wordpress 다운 및 설정
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress/ var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
cp -rp ./tmp/wp-config.php /var/www/html/wordpress
rm -rf latest.tar.gz

service mysql start
echo "CREATE DATABASE IF NOT EXISTS wordpress;" | mysql -u root --skip-password
echo "CREATE USER 'suylee'@'localhost' IDENTIFIED BY '9752';" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'suylee'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# phpmyadmin 다운 및 설정
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz 
tar -xvf phpMyAdmin-5.0.4-all-languages.tar.gz
rm -rf phpMyAdmin-5.0.4-all-languages.tar.gz
mv phpMyAdmin-5.0.4-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
cp -rp /tmp/config.inc.php /var/www/html/phpmyadmin/

service nginx start
service php7.3-fpm start
service mysql restart

bash
