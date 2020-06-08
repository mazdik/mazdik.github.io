#!/bin/sh

for sqlfile in /home/user/1backup/*.sql
do

zip -r -9 $sqlfile.zip $sqlfile
rm -rf $sqlfile

done