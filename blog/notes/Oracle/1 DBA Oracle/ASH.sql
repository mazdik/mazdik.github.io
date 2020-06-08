--Active Session History - ASH
/*
Oracle Database собирает статистику Active Session History 
(состоящую в основном из статистики ожидания для различных событий) для всех активных сеансов каждую секунду, и сохраняет ее в циклическом буфере в SGA. 
Таким образом, ASH записывает самую свежую активность сеанса (за последние 5-10 минут).
*/
--в памяти
SELECT * FROM V$ACTIVE_SESSION_HISTORY;
--на диске (после заполнения буфера памяти сбрасывается на диск)
SELECT * FROM DBA_HIST_ACTIVE_SESSION_HISTORY;

--Генерация отчета ASH
$ORACLE_HOME/rdbms/admin/ashrpt.sql
@D:\oracle\product\10.2.0\db_1\rdbms\admin\ashrpt.sql

--Объекты с самыми высокими показателями по событиям ожидания (в последние 15 минут)
SELECT o.object_name, o.object_type, a.event,
SUM(a.wait_time + a.time_waited) total_wait_time
FROM v$active_session_history a, dba_objects o
WHERE a.sample_time between sysdate - 30/2880 and sysdate
AND a.current_obj# = o.object_id
GROUP BY o.object_name, o.object_type, a.event
ORDER BY total_wait_time DESC;

--Самые важные события ожидания (в последние 15 минут)
SELECT a.event,
SUM(a.wait_time + a.time_waited) total_wait_time
FROM v$active_session_history a
WHERE a.sample_time between
sysdate - 30/2880 and sysdate
GROUP BY a.event
ORDER BY total_wait_time DESC;

--Пользователи с наиболее высокими показателями по времени ожидания(в последние 15 минут)
SELECT s.sid, s.username,
SUM(a.wait_time + a.time_waited) total_wait_time
FROM v$active_session_history a, v$session s
WHERE a.sample_time between sysdate - 30/2880 and sysdate
AND a.session_id=s.sid
GROUP BY s.sid, s.username
ORDER BY total_wait_time DESC;

--Определение SQL-кода с наиболее высокими показателями по времени ожидания(в последние 15 минут)
SELECT a.user_id,d.username,s.sql_text,
SUM(a.wait_time + a.time_waited) total_wait_time
FROM v$active_session_history a, v$sqlarea s, dba_users d
WHERE a.sample_time between sysdate - 30/2880 and sysdate
AND a.sql_id = s.sql_id
AND a.user_id = d.user_id
GROUP BY a.user_id,s.sql_text, d.username
ORDER BY total_wait_time DESC;

/* История sql */
select * from v$sql t where t.LAST_ACTIVE_TIME > sysdate - 1/24/60
and t.PARSING_SCHEMA_NAME in ('WELLOP_VD')
and t.MODULE <> 'PL/SQL Developer'

