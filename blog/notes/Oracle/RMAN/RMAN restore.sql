--Rman database restore: - using current control file
RMAN> startup force mount;
RMAN> restore database;
RMAN> recover database;
RMAN> alter database open;

--Rman database restore: - using backup control file
RMAN> startup nomount;
RMAN> restore controlfile from autobackup;
RMAN> alter database mount;
RMAN> list backup;
RMAN> restore database;
RMAN> recover database;
RMAN> alter database open resetlogs;

--Rman backup in non-archivelog mode:
RMAN> SHUTDOWN IMMEDIATE;
RMAN> STARTUP FORCE DBA;
RMAN> SHUTDOWN IMMEDIATE;
RMAN> STARTUP MOUNT;
RMAN> BACKUP DATABASE;
--or
RMAN> BACKUP AS COPY DATABASE;
RMAN> ALTER DATABASE OPEN;

--Other rman backup
RMAN> BACKUP ARCHIVELOG from time 'sysdate-2';
RMAN> BACKUP TABLESPACE system, users, tools;
RMAN> BACKUP AS BACKUPSET DATAFILE
'ORACLE_HOME/oradata/trgt/users01.dbf',
'ORACLE_HOME/oradata/trg/tools01.dbf';
RMAN> BACKUP DATAFILE 1,3,5;
RMAN> BACKUP CURRENT CONTROLFILE TO '/backup/curr_cf.copy';
RMAN> BACKUP SPFILE;
RMAN> BACKUP BACKUPSET ALL;
RMAN> BACKUP archivelog;
RMAN> BACKUP archivelog all;
RMAN> BACKUP ARCHIVELOG FROM TIME 'SYSDATE-30' UNTIL TIME 'SYSDATE-7';

--Restore spfile from backup
RMAN> SET DBID 2272089540
RMAN> STARTUP FORCE NOMOUNT
RMAN> RESTORE SPFILE FROM AUTOBACKUP;
RMAN> RESTORE SPFILE from 'C:\fra\MURGB\AUTOBACKUP\CF_MURGB_C-2272089540-20130401-06';

--Tablespace
RMAN> STARTUP MOUNT;
RMAN> SQL 'ALTER TABLESPACE users OFFLINE';
RMAN> RESTORE TABLESPACE users;
RMAN> RECOVER TABLESPACE users;
RMAN> SQL 'ALTER TABLESPACE users ONLINE';

--To recover a NOARCHIVELOG database (NOREDO)
RMAN> RESTORE DATABASE;
RMAN> RECOVER DATABASE NOREDO;
RMAN> ALTER DATABASE OPEN RESETLOGS;

-- Восстановление из последнего бекапа на 15 минут назад
RMAN> run{
shutdown immediate;
startup mount;
set until time "sysdate-15/(24*60)"; 
-- set until time "to_date('2010-06-01 12:50:30', 'yyyy-mm-dd hh24:mi:ss')"; 
restore database; 
recover database;
alter database open resetlogs;}

--Возобновить с того же места, где она была прервана
RMAN> BACKUP DATABASE NOT BACKED UP SINCE TIME 'SYSDATE-1';

/* RMAN in noarchivelog mode */
run 
{
shutdown immediate;
startup mount;
backup database;
}


