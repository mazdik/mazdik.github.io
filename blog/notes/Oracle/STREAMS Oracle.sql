--Настройка системных параметров БД:
sqlplus / as sysdba
ALTER SYSTEM SET global_names = true scope= both;
ALTER SYSTEM SET parallel_max_servers = 10 scope= both;
ALTER SYSTEM SET shared_pool_size = 256M scope= both;
--ALTER SYSTEM SET streams_pool_size = 256M scope= both;
ALTER SYSTEM SET java_pool_size = 100M scope= both;
--параметры
select t.name, t.value from v$parameter t 
where t.NAME in ('global_names', 'parallel_max_servers', 'shared_pool_size', 'java_pool_size', 'streams_pool_size');

--GLOBAL_NAME
SELECT * FROM GLOBAL_NAME;
ALTER DATABASE RENAME GLOBAL_NAME TO SIM.TST1;
ALTER DATABASE RENAME GLOBAL_NAME TO SIM.TST2;

--Настройка Oracle Net Services
SIM.TST1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.56.104)(PORT = 1521))
    (CONNECT_DATA =(SERVICE_NAME = SIM.TST1))
  )

SIM.TST2 =
  (DESCRIPTION =
	(ADDRESS = (PROTOCOL = TCP)(HOST = 192.168.56.105)(PORT = 1521))
    (CONNECT_DATA =(SERVICE_NAME = SIM.TST2))
  )

--listener.ora
SID_LIST_LISTENER =
  (SID_LIST =
    (SID_DESC =
      (SID_NAME = CLRExtProc)
      (ORACLE_HOME = D:\app\product\11.2.0\dbhome_1)
      (PROGRAM = extproc)
      (ENVS = "EXTPROC_DLLS=ONLY:D:\app\product\11.2.0\dbhome_1\bin\oraclr11.dll")
    )
    (SID_DESC =
      (GLOBAL_DBNAME=SIM.TST1)
      (ORACLE_HOME = D:\app\product\11.2.0\dbhome_1)
      (SID_NAME=SIM)
    )
  )

--Создание табличного пространства администратора Streams:
CREATE TABLESPACE streams_tbs DATAFILE 'D:\app\oradata\SIM\STREAMS_TBS.DBF'
	SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;

--Cоздание администратора streams с привилегиями Oracle Streams:
CREATE USER STRMADMIN IDENTIFIED BY "master"
	DEFAULT TABLESPACE streams_tbs
	QUOTA UNLIMITED ON streams_tbs;
-- права
GRANT CONNECT, RESOURCE, DBA TO STRMADMIN;
-- привилегии администратора Streams
BEGIN
	DBMS_STREAMS_AUTH.GRANT_ADMIN_PRIVILEGE(grantee => 'strmadmin');
END;
/

--Создание связей баз данных (database links):
connect STRMADMIN/master@SIM.TST1
CREATE DATABASE LINK SIM.TST2 CONNECT TO STRMADMIN IDENTIFIED BY master USING 'SIM.TST2';

connect STRMADMIN/master@SIM.TST2
CREATE DATABASE LINK SIM.TST1 CONNECT TO STRMADMIN IDENTIFIED BY master USING 'SIM.TST1';

-- просмотреть связи базы данных
SELECT * FROM ALL_DB_LINKS;
-- протестировать связь базы данных
SELECT * FROM DUAL@SIM.TST2;
SELECT * FROM DUAL@SIM.TST1;

--Создание очередей (Queue):
connect STRMADMIN/master@SIM.TST1
BEGIN
        DBMS_STREAMS_ADM.SET_UP_QUEUE (
        QUEUE_TABLE  => 'C1_STREAM_Q1_QT',
        QUEUE_NAME   => 'C1_STREAM_Q1',
        QUEUE_USER   => 'STRMADMIN');
END;
/
connect STRMADMIN/master@SIM.TST2
BEGIN
        DBMS_STREAMS_ADM.SET_UP_QUEUE (
        QUEUE_TABLE  => 'A1_STREAM_Q1_QT',
        QUEUE_NAME   => 'A1_STREAM_Q1',
        QUEUE_USER   => 'STRMADMIN');
END;
/

--Проверка
SELECT * FROM user_queues;


--Create capture at source:
connect STRMADMIN/master@SIM.TST1
BEGIN
DBMS_STREAMS_ADM.ADD_SCHEMA_RULES(
   schema_name         =>'REPL',
   streams_type        =>'CAPTURE',
   streams_name        =>'C1_STREAM',
   queue_name          =>'STRMADMIN.C1_STREAM_Q1',
   include_dml         =>TRUE,
   include_ddl         =>TRUE,
   source_database     =>'SIM.TST1');
END;
/

--Проверка
SELECT * FROM all_capture;

--Создание процессов применения (Apply process):
--Create apply process at target
connect STRMADMIN/master@SIM.TST2
BEGIN
	DBMS_STREAMS_ADM.ADD_SCHEMA_RULES (
	SCHEMA_NAME             => 'REPL',
	STREAMS_TYPE            => 'APPLY',
	STREAMS_NAME            => 'A1_STREAM',
	QUEUE_NAME              => 'STRMADMIN.A1_STREAM_Q1',
	INCLUDE_DML             => TRUE,
	INCLUDE_DDL             => TRUE,
	SOURCE_DATABASE         => 'SIM.TST1');
END;
/
-- не выключать процесс при возникновении ошибки
BEGIN
  DBMS_APPLY_ADM.SET_PARAMETER(
    apply_name => 'A1_STREAM',
    parameter  => 'disable_on_error',
    value      => 'n');
END;
/

--Проверка
SELECT * FROM all_apply;

--Процесс передачи изменений (Propagation process):
--Create propagation at source
connect STRMADMIN/master@SIM.TST1
BEGIN
        DBMS_STREAMS_ADM.ADD_SCHEMA_PROPAGATION_RULES (
        SCHEMA_NAME             => 'REPL',
        STREAMS_NAME            => 'P1_STREAM',
        SOURCE_QUEUE_NAME       => 'STRMADMIN.C1_STREAM_Q1',
        DESTINATION_QUEUE_NAME  => 'STRMADMIN.A1_STREAM_Q1@SIM.TST2', 
        INCLUDE_DML             =>  TRUE,
        INCLUDE_DDL             =>  TRUE); 
END;
/

--Проверка
SELECT * FROM dba_propagation;

--На обеих базах
CREATE OR REPLACE DIRECTORY DMPDIR AS 'D:\temp';

--Первоначальная синхронизация таблиц (если необходимо):
--At source TST1...
SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER FROM DUAL; --439859059604
--expdp STRMADMIN/master@SIM.TST1 SCHEMAS=REPL DIRECTORY=DMPDIR DUMPFILE=REPL.dmp logfile=REPL.log PARALLEL=4 FLASHBACK_SCN=<scn>

--At Target TST2...
--impdp STRMADMIN/master@SIM.TST2 SCHEMAS=REPL DIRECTORY=DMPDIR DUMPFILE=REPL.dmp logfile=REPL.log PARALLEL=4
--синхронизация схемы по сети
impdp STRMADMIN/master@SIM.TST2 DIRECTORY=DMPDIR NETWORK_LINK=SIM.TST1 SCHEMAS=REPL flashback_scn=439859059604

--Check if schema instantiation is working fine..
select * from DBA_APPLY_INSTANTIATED_SCHEMAS;

--Установка контрольных точек (необходимо для начала отчета перехвата изменений):
connect STRMADMIN/master@SIM.TST2
declare
   v_scn number;
begin
    v_scn := dbms_flashback.get_system_change_number();
    dbms_output.put_line('Scn : ' || v_scn);
    dbms_apply_adm.set_schema_instantiation_scn(
                    source_schema_name => 'REPL',
                    source_database_name => 'SIM.TST1',
                    instantiation_scn => v_scn,
                    recursive => true);
end;
/

--Запуск процессов применения и передачи:
connect STRMADMIN/master@SIM.TST2
exec DBMS_APPLY_ADM.START_APPLY('A1_STREAM');
--
connect STRMADMIN/master@SIM.TST1
exec DBMS_CAPTURE_ADM.START_CAPTURE('C1_STREAM');

----------------------------------------------------------
--Удаление Apply
begin
  dbms_apply_adm.drop_apply('apply_b', true);
end;
--Удаление Queue
connect STRMADMIN/master@SIM.TST1
begin
  dbms_streams_adm.remove_queue('C1_STREAM_Q1', true);
end;
/
connect STRMADMIN/master@SIM.TST2
begin
  dbms_streams_adm.remove_queue('A1_STREAM_Q1', true);
end;
/

--Стоп
connect STRMADMIN/master@SIM.TST2
exec DBMS_APPLY_ADM.STOP_APPLY('A1_STREAM');
--
connect STRMADMIN/master@SIM.TST1
exec DBMS_CAPTURE_ADM.STOP_CAPTURE('C1_STREAM');
begin
DBMS_PROPAGATION_ADM.STOP_PROPAGATION(
	PROPAGATION_NAME=> 'P1_STREAM',
	FORCE => FALSE);
end;
/

--------------- Полное удаление --------------------------
connect / as sysdba
execute DBMS_STREAMS_ADM.REMOVE_STREAMS_CONFIGURATION();
drop user strmadmin cascade;
--check the following view and confirm all views are empty.
SELECT * FROM sys.streams$_process_params;
/
SELECT * FROM sys.streams$_rules;
/
SELECT * FROM sys.streams$_capture_process;
/
SELECT * FROM sys.streams$_apply_process;
/
SELECT * FROM sys.streams$_apply_milestone;
/
SELECT * FROM sys.streams$_apply_progress;
