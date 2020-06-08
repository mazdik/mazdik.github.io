show all;

# report
report need backup database;
report obsolete;
report schema;
report unrecoverable;

# list
list backup by file;
list backup of database by backup;
list expired backup;
list expired copy;
list backup;
list backup summary;
list backup recoverable;

LIST COPY;
LIST ARCHIVELOG ALL;
LIST SCRIPT NAMES;
LIST GLOBAL SCRIPT NAMES;

LIST INCARNATION;

SQL> archive log list;

--Просмотр списка неполадок
RMAN> list failure;
RMAN> advise failure;