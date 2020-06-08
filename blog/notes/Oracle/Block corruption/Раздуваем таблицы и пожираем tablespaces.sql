--http://habrahabr.ru/post/198606/

--После BACKUP VALIDATE DATABASE; посмотрели на наши битые блоки:
select * from v$database_block_corruption;

/* select 
    'alter database datafile '||
    file_name||
    ' '||
    ' autoextend off;'
from 
    dba_data_files where TABLESPACE_NAME='REPL';
	 */
	
--отключить autoextend для всех файлов нашего TS
alter database datafile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\REPL01.DBF'  autoextend off;



DECLARE
type ARR_TABLE is table of varchar2(13);
TBLS ARR_TABLE:=ARR_TABLE();
I number;
SPACE_AVAILABLE float;
--Константа с целевым tablespace
TABLESPACE_FOR_FULL CONSTANT varchar2(20) := 'REPL';
--Константа со схемой. Почему бы нет?
USER_SCHEMA CONSTANT varchar2(20) := 'REPL';

--Вычисляем свободное место в TS
function TABLESPACE_FREESIZE(TN varchar2) return number
as si number; 
begin
  SELECT round(sum(bytes)/1048576,2) into si from DBA_FREE_SPACE where TABLESPACE_NAME = TN;
  return SI;
end TABLESPACE_FREESIZE;

--Создание и раздувание очередной таблицы пока не выскочит ora-1653
procedure create_new_tables as
  N number;
  I number;
  UNABLE_TO_EXTEND EXCEPTION;
  PRAGMA EXCEPTION_INIT(UNABLE_TO_EXTEND,-1653);
BEGIN
  N:=TBLS.COUNT;
  N:=N+1;
  TBLS.extend;
  TBLS(N):='TESTTABLE'||N;
  execute immediate 'create table '||USER_SCHEMA||'.'||TBLS(n)||' (id number(10), USER_NAME varchar2(10), CREATE_DATE date) tablespace '||TABLESPACE_FOR_FULL;
   WHILE true LOOP
    begin
      execute immediate 'alter table '||USER_SCHEMA||'.'||TBLS(n)||' allocate extent';
      EXCEPTION
      when UNABLE_TO_EXTEND then
      EXIT;
    end;
  END LOOP;
 end create_new_tables;

BEGIN
--Подготовка
  DBMS_OUTPUT.PUT_LINE( 'Time start: '||TO_CHAR(sysdate,  'DD-MM-YYYY HH24:MI:SS'));
  SPACE_AVAILABLE:=TABLESPACE_FREESIZE(TABLESPACE_FOR_FULL);
  DBMS_OUTPUT.PUT_LINE('Space available='||SPACE_AVAILABLE);

--Запуск 
  WHILE SPACE_AVAILABLE>0.001 LOOP
    CREATE_NEW_TABLES();
    SPACE_AVAILABLE:=TABLESPACE_FREESIZE(TABLESPACE_FOR_FULL);
--Когда функция TABLESPACE_FREESIZE начнет выдавать NULL вместо числа - цикл остановится.
  end LOOP;

--Очистка созданных таблиц
  for I in 1..TBLS.COUNT LOOP
    execute immediate 'drop table '||USER_SCHEMA||'.'||TBLS(I);
  end LOOP;
  DBMS_OUTPUT.PUT_LINE( 'Time end: '||TO_CHAR(sysdate,  'DD-MM-YYYY HH24:MI:SS'));
end;


-- включить autoextend
alter database datafile 'D:\oracle\product\10.2.0\oradata\orcl\REPL01.DBF' autoextend on next 64M maxsize 2G;


--Очистка корзины
begin
  for cur in (
    select decode(partition_name, null,
               segment_name,
               segment_name || ':' || partition_name) objectname,
           segment_type object_type,
           owner,
           tablespace_name,
           header_block
    from   dba_segments
    where  tablespace_name = 'REPL' and
           segment_name like 'BIN$%'
       ) loop
       execute immediate 'purge table '|| cur.owner ||'."'|| cur.objectname||'"';
       end loop;
  
end;

RMAN> BACKUP VALIDATE DATABASE;
-- результаты
select * from v$database_block_corruption;

