-- информация обо всех выполняющихся в текущий момент заданиях Data Pump
SELECT * FROM DBA_DATAPUMP_JOBS;

-- Представление DBA_DATAPUMP_SESSIONS позволяет выяснять, какие пользовательские сеансы в текущий момент подключены к заданию Data Pump
SELECT sid, serial#
FROM V$SESSION s, DBA_DATAPUMP_SESSIONS d
WHERE s.saddr = d.saddr;

-- сколько времени осталось до завершения выполнения задания Data Pump
SELECT opname, target_desc, sofar, totalwork FROM V$SESSION_LONGOPS;


--Применение API-интерфейса Data Pump для создания задания Data Pump Export
DECLARE
d1 NUMBER; -- Обработчик задания Data Pump
BEGIN
-- Создание задания Data Pump для экспорта.
d1 := DBMS_DATAPUMP.OPEN('EXPORT','SCHEMA',NULL,'TEST1','LATEST');
-- Указание одного файла дампа для задания.
DBMS_DATAPUMP.ADD_FILE(d1,'test1.dmp','DMPDIR');
-- Указание схемы.
DBMS_DATAPUMP.METADATA_FILTER(d1,'SCHEMA_EXPR','IN (''OE'')');
-- Запуск экспортного задания.
DBMS_DATAPUMP.START_JOB(d1);
-- Оповещение о завершении выполнения задания и отсоединение от него.
dbms_output.put_line('Job has completed');
dbms_datapump.detach(d1);
END;

--Применение API-интерфейса Data Pump для создания задания Data Pump Import
DECLARE
d1 NUMBER; -- Обработчик задания Data Pump
BEGIN
-- Создание задания Data Pump для выполнения "полного" импорта данных.
d1 := DBMS_DATAPUMP.OPEN('IMPORT','FULL',NULL,'TEST2');
-- Указание файла дампа для задания.
DBMS_DATAPUMP.ADD_FILE(d1,'example1.dmp','DMPDIR');
-- Указание, что объекты схемы должны быть перемещены из схемы oe в схему hr.
DBMS_DATAPUMP.METADATA_REMAP(d1,'REMAP_SCHEMA','oe','hr');
-- Запуск задания.
DBMS_DATAPUMP.START_JOB(h1);
-- Оповещение о завершении выполнения задания и аккуратное отсоединение от него.
dbms_output.put_line('Job has completed');
dbms_datapump.detach(h1);
END;

--Остановить импорт data pump
DECLARE
  h1 NUMBER;
BEGIN
  h1 := DBMS_DATAPUMP.ATTACH('SYS_IMPORT_SCHEMA_01', 'SYSTEM');
  DBMS_DATAPUMP.STOP_JOB(h1, 1, 0);
END;

--DAILY FULL EXPORT
CREATE OR REPLACE PROCEDURE DAILY_EXPORT AS
  l_dp_handle      NUMBER;
  v_job_state      varchar2(4000);
  v_day            varchar2(20);
BEGIN
  select rtrim(to_char(sysdate,'DAY')) into v_day from dual;
  l_dp_handle := DBMS_DATAPUMP.open(operation   => 'EXPORT',
                                    job_mode    => 'FULL',
                                    remote_link => NULL,
                                    version     => 'LATEST');
  DBMS_DATAPUMP.add_file(handle    => l_dp_handle,
                         filename  => v_day||'.dmp',
                         directory => 'DATA_PUMP_DIR',
                         reusefile => 1);
  DBMS_DATAPUMP.add_file(handle    => l_dp_handle,
                         filename  => v_day||'.log',
                         directory => 'DATA_PUMP_DIR',
                         filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE,
                         reusefile => 1);
  DBMS_DATAPUMP.start_job(l_dp_handle);
  DBMS_DATAPUMP.WAIT_FOR_JOB(l_dp_handle, v_job_state);
  DBMS_OUTPUT.PUT_LINE(v_job_state);
END;

/* METADATA_ONLY пустые таблицы */
DBMS_DATAPUMP.DATA_FILTER(l_dp_handle, 'INCLUDE_ROWS', 0, NULL, NULL);

/* IMPORT */
DECLARE
D1 NUMBER;
BEGIN
D1 := DBMS_DATAPUMP.OPEN('IMPORT','SCHEMA',NULL,'JOB_NAME','LATEST');
DBMS_DATAPUMP.ADD_FILE(D1,'test1.dmp','DATA_PUMP_DIR');
DBMS_DATAPUMP.START_JOB(D1);
dbms_output.put_line('Job has completed');
dbms_datapump.detach(D1);
END;


