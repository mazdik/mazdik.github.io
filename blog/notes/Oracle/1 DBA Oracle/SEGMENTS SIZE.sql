--размер сегментов в МБ
select  DECODE (partition_name,
               NULL, segment_name,
                segment_name || ':' || partition_name
              ) segment_name,
       owner, tablespace_name, segment_type,
       round(bytes /1024/1024, 2) mb
from   dba_segments
WHERE tablespace_name = 'USERS'
order by bytes desc

--размер одной таблицы
select round(bytes /1024/1024, 2) mb
from   dba_segments
WHERE segment_name = upper('ZREPL_META')

--1 способ узнать размер таблицы с условием.
--AVG_ROW_LEN - средняя длина строки в байтах в таблице, умножаем его на количество строк.
select
(select count(*) from CHEQUE t where trunc(t.BEGIN_DATE, 'YEAR')=trunc(sysdate-365*2, 'YEAR')) *
(select AVG_ROW_LEN from SYS.DBA_TABLES where TABLE_NAME = 'CHEQUE')
as rows_size
from dual;

--2 способ узнать размер таблицы с условием
--Выборочный экспорт содержащихся в строках таблицы данных с помощью оператора SQL. 
--В Data Pump по умолчанию работает BLOCKS method. Она берет размер блока базы данных и умножает его на количество блоков, которое потребуется всем объектам вместе.
--ESTIMATE_ONLY=Y не работает вместе с QUERY
expdp parfile=D:\expdp.txt
USERID=lider/master@KAZS
TABLES=CHEQUE
QUERY=CHEQUE:"where trunc(BEGIN_DATE, 'YEAR')=trunc(sysdate, 'YEAR')"
DIRECTORY=DMPDIR
DUMPFILE=EXPDP.dmp
LOGFILE=EXPDP.log

--Результаты:
--1) 9554547 (9.112 MB)
--2) exported "LIDER"."CHEQUE"	8.199 MB   86074 rows
