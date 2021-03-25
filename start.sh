#!/bin/sh

service nginx start
service php7.4-fpm start
#コンテナの起動に必要
tail -f /dev/null
