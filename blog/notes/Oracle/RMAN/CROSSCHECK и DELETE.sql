--Delete all backups:
DELETE NOPROMPT BACKUP;
DELETE NOPROMPT COPY;
DELETE NOPROMPT ARCHIVELOG ALL;
DELETE NOPROMPT BACKUPSET;
DELETE NOPROMPT OBSOLETE;
--удалить недействительные записи в каталоге восстановления с параметром FORCE 
DELETE FORCE NOPROMPT OBSOLETE;

--crosscheck
crosscheck archivelog all;
crosscheck backup;
crosscheck backupset;
crosscheck copy;
delete noprompt expired archivelog all;
delete noprompt expired backup;
delete noprompt expired backupset;
delete noprompt expired copy;
delete noprompt obsolete;

SQL "ALTER SYSTEM SWITCH LOGFILE";
SQL "ALTER SYSTEM ARCHIVE LOG CURRENT";

DELETE BACKUP OF DATABASE COMPLETED BEFORE 'SYSDATE-7';
delete backup completed before 'SYSDATE-7';

rman target / nocatalog
D:\oracle\product\10.2.0\db_1\bin\rman target / nocatalog
--сбэкапит архивные журналы и удалит их
backup archivelog all delete all input;

