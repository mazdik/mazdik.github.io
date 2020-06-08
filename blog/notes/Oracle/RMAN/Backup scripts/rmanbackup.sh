# export variables
ORACLE_BASE=/u01/app/oracle
export ORACLE_BASE
ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
export ORACLE_HOME
ORACLE_SID=testdb
export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH
export PATH
week=`date +%w`
LOGFILE=/u01/app/oracle/admin/backup.log

rman target / <<ERMAN > $LOGFILE

set echo on;

CONFIGURE CONTROLFILE AUTOBACKUP ON;
#CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
CONFIGURE RETENTION POLICY TO REDUNDANCY 2;
CONFIGURE BACKUP OPTIMIZATION ON;
CONFIGURE DEVICE TYPE DISK BACKUP TYPE TO COMPRESSED BACKUPSET;

show all;
report unrecoverable;

# actual backup
backup database plus archivelog;

# controlfile/pfile backup
#sql 'ALTER DATABASE BACKUP CONTROLFILE TO TRACE';
sql "ALTER DATABASE BACKUP CONTROLFILE TO TRACE AS ''/u01/app/oracle/admin/controlfile.backup.${week}.sql'' reuse";
sql "CREATE PFILE=''/u01/app/oracle/admin/spfile.backup'' FROM SPFILE";

# delete obsolete;
# report obsolete;
delete force noprompt obsolete;

# crosscheck
crosscheck archivelog all;
delete noprompt expired archivelog all;
crosscheck backup;
delete noprompt expired backup;
crosscheck copy;
delete noprompt expired copy;

list backup;
list backup summary;
list backup recoverable;

#restore database validate;
#restore spfile validate;

exit
ERMAN
