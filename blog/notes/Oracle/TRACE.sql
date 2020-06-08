--Включить трассировку своей сессии
alter session set events '10046 trace name context forever, level 12';
--Выключается трассировка своей сессии так:
alter session set events '10046 trace name context off';

--Трассировка всех сессий базы
alter system set events='10046 trace name context forever,level 12';
alter system set events='10046 trace name context off';

--Активизация механизма трассировки SQL
ALTER SESSION SET sql_trace=true;
DBMS_SESSION.SET_SQL_TRACE(true);

--Для активизации механизма трассировки в сеансе другого пользователя (не рекомендуется)
DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION
--Сквозная  трассировка (end-to-end tracing)
DBMS_MONITOR.SERV_MOD_ACT_TRACE_ENABLE(SERVICE_NAME=>'myservice', MODULE_NAME=>'batch_job');
DBMS_MONITOR.CLIENT_ID_TRACE_ENABLE(CLIENT_ID=>'salapati');
--SID и SERIAL# в представлении V$SESSION
DBMS_MONITOR.SESSION_TRACE_ENABLE(SESSION_ID=>111, SERIAL_NUM=>23, WAITS=>true, BINDS=>true);
DBMS_MONITOR.SESSION_TRACE_DISABLE(111,23);;

--DBMS_MONITOR
select * from V$SQL_MONITOR

--Трассировочный файл необходимо обработать утилитой TKPROF:
cd %ORACLE_HOME%/admin/SID/udump
tkprof my_trace_file.trc output=my_file.txt

/*
1  — стандартный уровень SQL_TRACE (Default)
4  — уровень 1 + трейс значений связанных переменных (binds)
8  — уровень 1 + трейс событий ожидания (waits)…
12 = 4+8 уровень 1 + трейсы значений связанных переменных (binds) и событий ожидания (waits)«
*/