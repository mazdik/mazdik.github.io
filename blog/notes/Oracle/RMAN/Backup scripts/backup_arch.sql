run {
CROSSCHECK ARCHIVELOG ALL;
# Backup Archived Logs
sql 'alter system archive log current';
BACKUP DEVICE TYPE DISK
FORMAT 'D:\Backup\arch_%e_%h_%u.arc' TAG 'arch'
ARCHIVELOG ALL NOT BACKED UP DELETE ALL INPUT;
# Current controlfile
BACKUP DEVICE TYPE DISK CURRENT CONTROLFILE
FORMAT 'D:\Backup\ctrl_%d_%I_%u.ctl' TAG 'ctrl';
DELETE NOPROMPT OBSOLETE;
DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
}



