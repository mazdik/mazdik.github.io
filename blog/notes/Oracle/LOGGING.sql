--FORCE LOGGING
--Этот режим нужен для принудительной записи транзакций в redo logs даже для операций, выполняемых с опцией NOLOGGING.
--больше используется в Data Guard (standby databases)

--Узнать включен ли:
select log_mode, force_logging from V$DATABASE

--Включить:
ALTER DATABASE force logging;
ALTER TABLESPACE users FORCE LOGGING;

--Выключить:
ALTER DATABASE no force logging;
ALTER TABLESPACE users NO FORCE LOGGING;


--LOGGING
select tablespace_name, logging, status from dba_tablespaces

select owner, tablespace_name, logging, count(*) from DBA_TABLES
group by owner, tablespace_name, logging
order by logging, owner


--NOLOGGING 
--для уменьшения записи в redo logs .

ALTER TABLE t1 NOLOGGING;

ALTER TABLE t1 LOGGING;