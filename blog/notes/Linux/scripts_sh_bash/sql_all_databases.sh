#!/bin/sh

USER=wppack
PASS=picapica
DBHOST=localhost
path="/home/user/Downloads/"


for (( i=1 ; $i<=177 ; i=(($i+1)) )) 
do 
  echo 'wppack'$i 
    /opt/lampp/bin/mysql -h $DBHOST -u $USER --password=$PASS --default_character_set utf8 -D 'wppack'$i < $path/wp_sql.sql >> output.txt
done