@echo off
chcp 1251
rman target / @backup.txt > backup_%date%.log
rem в планировщике нужно указать рабочую папку
rem pause Press any key to exit
exit  
exit  