# lithium + nginx
#
# VERSION               0.1

FROM ubuntu

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get  install nginx -y
RUN apt-get install -y python-software-properties
RUN add-apt-repository ppa:ondrej/php5 -y
RUN apt-get update

#install php & extensions
RUN apt-get install -y php5-fpm php-apc php5-curl php5-gd php-pear php5-xmlrpc php5-imagick php5-imap php5-mcrypt php5-memcache git php5-dev php5-cli php5-memcached php5-mysql php5-sqlite


#install openssh
RUN apt-get install -y  openssh-server
RUN mkdir /var/run/sshd

#set root password
RUN echo "root:##Hd2013" | chpasswd
RUN mkdir -p /usr/share/nginx/www
ADD https://raw.github.com/thesyncim/DockerConf/master/dockerfiles/base-lithium/conf/nginx.conf /etc/nginx/nginx.conf
ADD https://raw.github.com/thesyncim/DockerConf/master/dockerfiles/base-lithium/conf/www.conf /etc/php5/fpm/pool.d/www.conf
ADD https://raw.github.com/thesyncim/DockerConf/master/dockerfiles/base-lithium/conf/default /etc/nginx/sites-available/default


RUN rm -rf /usr/share/nginx/www/
#install lithium
RUN git clone git://github.com/UnionOfRAD/framework.git /usr/share/nginx/www  
RUN  cd /usr/share/nginx/www/ && git submodule init && git submodule update
RUN chmod 777 /usr/share/nginx/www/app/resources/

RUN pecl install mongo
RUN echo "extension=mongo.so"> /etc/php5/fpm/conf.d/mongo.ini

RUN pecl install redis 
RUN echo "extension=redis.so"> /etc/php5/fpm/conf.d/redis.ini
		      


ADD https://raw.github.com/thesyncim/DockerConf/master/dockerfiles/base-lithium/start.sh /

RUN chmod +x /start.sh

EXPOSE 80
EXPOSE 22

CMD    ["/start.sh"]

