--Как узнать в каком режиме база ARCHIVELOG/NOARCHIVELOG? 
select log_mode from v$database;

--включить ARCHIVELOG
shutdown immediate;
startup mount;
alter database archivelog;
alter database open;

--выключить ARCHIVELOG
shutdown immediate;
startup mount;
alter database noarchivelog;
alter database open;

--под sqlplus
archive log list
show parameter recovery_file_dest
show parameter recovery_file_dest_size

ALTER SYSTEM set DB_RECOVERY_FILE_DEST_SIZE = 200G scope = both;
ALTER SYSTEM set DB_RECOVERY_FILE_DEST = 'D:\oracle\product\10.2.0\flash_recovery_area' scope = both;

--проверка
alter system switch logfile;
ALTER SYSTEM ARCHIVE LOG CURRENT;

--Время переключения
alter system set ARCHIVE_LAG_TARGET = 1800 scope=both;

--Вместо LOG_ARCHIVE_DEST и LOG_ARCHIVE_DUPLEX_DEST рекомендуется использовать LOG_ARCHIVE_DEST_n
--выключить DB_RECOVERY_FILE_DEST (оставить LOG_ARCHIVE_DEST) и перезапустить базу
ALTER SYSTEM RESET DB_RECOVERY_FILE_DEST SCOPE=spfile sid='*';

-- LOG_ARCHIVE_DEST_1
alter system set LOG_ARCHIVE_DEST_1='LOCATION=D:\bcp\arc' scope=both;

