/* SQL выборка общего размера базы oracle (в Гб) = общий размер бэкапов рмана + общий размер архивлогов + общий размер дата файлов базы */
select round(sum(bsize)/1024/1024, 2)  as gsize from (
select sum(bp.bytes/1024) as bsize
          from v$backup_set bs, v$backup_piece bp
         where bs.set_stamp = bp.set_stamp
           and bs.set_count = bp.set_count
           and bp.status = 'A'
         union all
--SELECT SPACE_USED/1024 as bsize FROM V$RECOVERY_FILE_DEST
select sum(t.BLOCKS*t.BLOCK_SIZE)/1024 as bsize from V$ARCHIVED_LOG t where t.STATUS='A'
union all
select sum(bytes)/1024 as bsize from SYS.DBA_DATA_FILES
)

/* ------------------ */
select ctime "Date",
       decode(backup_type, 'L', 'Archive Log', 'D', 'Full', 'Incremental') backup_type,
       bsize "Size MB"
  from (select trunc(bp.completion_time) ctime,
               backup_type,
               round(sum(bp.bytes / 1024 / 1024), 2) bsize
          from v$backup_set bs, v$backup_piece bp
         where bs.set_stamp = bp.set_stamp
           and bs.set_count = bp.set_count
           and bp.status = 'A'
         group by trunc(bp.completion_time), backup_type)
 order by 1, 2;

 --
 SELECT file_type, space_used * percent_space_used / 100 / 1024 / 1024 used,
           space_reclaimable * percent_space_reclaimable / 100 / 1024 / 1024
           reclaimable, b.number_of_files
           FROM V$RECOVERY_FILE_DEST A, V$FLASH_RECOVERY_AREA_USAGE B

--значения всех конфигурационных параметров RMAN, для которых были изменены принятые по умолчанию значения
SELECT * FROM V$RMAN_CONFIGURATION;
--позволяет наблюдать за выполнением заданий
SELECT * FROM V$RMAN_OUTPUT;
--отображает сведения о состоянии всех выполненных заданий и команд
SELECT * FROM V$RMAN_STATUS;
--получить информацию о ходе выполнения операций резервного копирования
SELECT TO_CHAR(start_time,'DD-MON-YY HH24:MI') "Start of backup",Sofar, 
totalwork, elapsed_seconds/60 "ELAPSED TIME IN MINUTES",
ROUND(sofar/totalwork*100,2) "Percentage Completed so far"
FROM v$session_longops
WHERE opname='prod1_dbbackup';
--помогает определять, не находятся ли какие-то файлы данных все еще в режиме резервного копирования
SELECT * FROM V$BACKUP;
--список всех файлов данных, которые принадлежат всем подлежащим резервному копированию табличным пространствам
SELECT * FROM V$DATAFILE;
--оперативные журналы повторного выполнения
SELECT * FROM V$LOG;
--отображает накопленную в управляющем файле информацию об архивных журналах
SELECT * FROM V$ARCHIVED_LOG;
--отображает перечень тех журналов повторного выполнения, которые были заархивированы
SELECT * FROM V$LOG_HISTORY;
--какие файлы нуждаются в восстановлении
SELECT * FROM V$RECOVER_FILE;
--более подробная информация о файлах, которые может потребоваться восстанавливать
SELECT r.FILE# AS df#, d.NAME AS df_name, t.NAME AS tbsp_name,
d.STATUS, r.ERROR, r.CHANGE#, r.TIME
FROM V$RECOVER_FILE r, V$DATAFILE d, V$TABLESPACE t
WHERE t.TS# = d.TS#
AND d.FILE# = r.FILE#
/*
Если в результате выполнения запроса возвращается сообщение no rows selected
(не были выбраны никакие строки), это значит, что ни один из файлов данных не нуждается в восстановлении.
Если в столбце ERROR содержится значение NULL, а в столбце RECOVER —  значение YES, 
это значит, что восстановление можно выполнить и без восстановления копии файла данных.
*/
SELECT file#, status, error, recover, tablespace_name, name
FROM V$DATAFILE_HEADER
WHERE RECOVER = 'YES' OR (RECOVER IS NULL AND ERROR IS NOT NULL);

