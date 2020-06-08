conn lider/master@KAZS as sysdba
ALTER SYSTEM SET log_archive_dest='D:\bcp\arc' SCOPE=spfile;
ALTER SYSTEM SET log_archive_format = 'arch_%r_%t_%s.arc' SCOPE=spfile;
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
alter system switch logfile;
exit;