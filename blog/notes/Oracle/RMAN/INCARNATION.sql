/*
Всякий раз, когда применяется команда OPEN RESETLOGS, происходит изменение 
инкарнации базы данных, и начинает действие новая инкарнация.
В представлении V$LOG_HISTORY есть два столбца — RESETLOGS_CHANGE# и RESETLOGS_TIME, 
которые показывают, в какой инкар-нации базы данных находятся архивные журналы повторного выполнения.
*/
RMAN> LIST INCARNATION;
RMAN> STARTUP FORCE NOMOUNT;
RMAN> RESET DATABASE TO INCARNATION 2;
RMAN> RESTORE CONTROLFILE FROM AUTOBACKUP;
RMAN> ALTER DATABASE MOUNT;
RMAN> RESTORE DATABASE;
RMAN> RECOVER DATABASE UNTIL SCN 1000
RMAN> ALTER DATABASE OPEN RESETLOGS;