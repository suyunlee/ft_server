FROM	debian:buster

LABEL	maintainer="suylee@student.42seoul.kr"

RUN		apt-get update && apt-get -y upgrade
RUN		apt-get -y install nginx
RUN		apt-get -y install mariadb-server
RUN		apt-get -y install php-mysql php7.3-fpm php-mbstring
RUN		apt-get -y install wget openssl vim


COPY	./srcs/run.sh ./
COPY	./srcs/default ./tmp
COPY	./srcs/wp-config.php ./tmp
COPY	./srcs/config.inc.php ./tmp

EXPOSE	80 443

CMD 	bash run.sh

