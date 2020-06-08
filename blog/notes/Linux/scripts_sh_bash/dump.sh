#!/bin/bash
mysqldump -uroot -pzxcasd pvp > /home/line/server/dump/pvp.sql;tar czf /home/line/server/dump/pvp-`date +%d.%m.%y`.tgz /home/line/server/dump/pvp.sql

find /home/line/server/dump -mtime +7 -exec rm -fv {} \;
