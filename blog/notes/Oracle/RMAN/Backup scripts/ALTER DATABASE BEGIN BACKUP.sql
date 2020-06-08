--—ценарий пользовательского горячего резервного копирования
ALTER DATABASE BEGIN BACKUP;
--и скопировать все файлы данных
ALTER DATABASE END BACKUP;
ALTER DATABASE BACKUP CONTROLFILE TO $BACKUP_DIR/control;
ALTER SYSTEM SWITCH LOGFILE;