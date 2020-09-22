# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: hjung <hjung@student.42seoul.kr>           +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/21 00:00:04 by hjung             #+#    #+#              #
#    Updated: 2020/09/23 00:50:45 by hjung            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

# nginx install  
RUN apt-get update
RUN apt-get -y install nginx

# create Self Signed certification
RUN apt-get -y install openssl vim
RUN openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Yoon/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
RUN mv localhost.dev.key /etc/ssl/private
RUN mv localhost.dev.crt /etc/ssl/certs
RUN chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

# php-fpm install
RUN apt-get install -y php-fpm

# MySQL(Maria DB) install
RUN apt-get -y install mariadb-server php-mysql

# phpMyAdmin install
RUN apt-get install -y wget
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
RUN tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.2-all-languages phpmyadmin
RUN mv phpmyadmin /var/www/html/

# phpMyAdmin setting
RUN cp -rp var/www/html/phpmyadmin/config.sample.inc.php var/www/html/phpmyadmin/config.inc.php 

# WordPress install
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz
RUN mv wordpress/ var/www/html/
RUN	chown -R www-data:www-data /var/www/html/wordpress

# WordPress settings
RUN cp var/www/html/wordpress/wp-config-sample.php var/www/html/wordpress/wp-config.php 

# copy src files
COPY ./srcs/default /etc/nginx/sites-available/default
COPY ./srcs/init_container.sh ./
COPY ./srcs/config.inc.php var/www/html/phpmyadmin/config.inc.php
COPY ./srcs/wp-config.php var/www/html/wordpress/wp-config.php

CMD bash init_container.sh

EXPOSE 80
EXPOSE 443