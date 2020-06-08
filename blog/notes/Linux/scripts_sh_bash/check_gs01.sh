#/bin/bash

if ps ax | grep -v grep | grep 'gs gs01' > /dev/null >> /PWServer/logs/check_gs01.log
then
echo "GameServer: Main World[gs01] is RUNNING."
else
echo "GameServer: Main World[gs01] is DOWN. Restarting Main World..."
cd /PWServer/gamed
./gs gs01
fi