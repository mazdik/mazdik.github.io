#!/bin/sh

USER=root
PASS=ghbdtnjktym
DBHOST=localhost
path="/wwwbackup/wppack_sql/"

for sqlfile in `ls $path`
do

        echo Loading ${sqlfile%.*} ...
        /opt/lampp/bin/mysql -h $DBHOST -u $USER --password=$PASS --default_character_set utf8 -D ${sqlfile%.*} < $path/$sqlfile
done
