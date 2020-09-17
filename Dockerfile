# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: hjung <hjung@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/09/17 22:06:14 by hjung             #+#    #+#              #
#    Updated: 2020/09/18 00:16:20 by hjung            ###   ########.fr        #
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

# nginx setting
COPY src/default /etc/nginx/sites-available/default

# php-fpm install
RUN apt-get -y install php-fpm
