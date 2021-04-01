# pull ubuntu 20.04 as base image
FROM ubuntu:20.04

# update packages
RUN set -x && \
    apt update && \
    apt upgrade -y

RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen ja_JP.UTF-8 \
    && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc

#sudo install
RUN apt-get update  \
    && apt-get install -y sudo

# R install
RUN apt install -y dirmngr gnupg apt-transport-https ca-certificates software-properties-common
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN apt install -y r-base

# nginx install
RUN apt-get install -y nginx

# vim install
RUN apt-get install -y vim

RUN apt-get install -y language-pack-ja-base language-pack-ja
RUN locale-gen ja_JP.UTF-8
RUN echo export LANG=ja_JP.UTF-8 >> ~/.profile
#RUN source ~/.profile

RUN apt install -y php-fpm

#RUN mkdir /ryukyu-lang
RUN mkdir /var/www/html/data
RUN chmod 777 /var/www/html/data
RUN mkdir /var/www/html/web
WORKDIR /var/www/html
COPY ./R /var/www/html/R
COPY ./default /etc/nginx/sites-enabled/default
COPY ./form.html /var/www/html/form.html
COPY ./upload2.php /var/www/html/web/upload2.php
COPY  ./R/install_command.R /
COPY ./php.ini /etc/nginx/sites-enabled/default
RUN Rscript /install_command.R
RUN rm /install_command.R
COPY  start.sh  /
RUN  chmod +x /start.sh
CMD  ["/start.sh"]