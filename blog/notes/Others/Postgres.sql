--Консоль
sudo -u postgres psql postgres
\l : list all databases
\du : list all users
\connect DBNAME

show max_connections;
show shared_buffers;

sudo service postgrespro-std-12.service restart

-- DUMP
pg_dump -U postgres -f postgres.sql
--Восстановление 
psql -U postgres -d postgres -f postgres.sql

-- pg_hba.conf
host    all    all    0.0.0.0/0    md5

/* ALTER SYSTEM SET */
ALTER SYSTEM SET max_connections = '400';
ALTER SYSTEM SET shared_buffers = '24GB';
ALTER SYSTEM SET random_page_cost = '1.1';
ALTER SYSTEM SET effective_io_concurrency = '300';
ALTER SYSTEM SET effective_cache_size = '48GB';
ALTER SYSTEM SET maintenance_work_mem = '2GB';
ALTER SYSTEM SET checkpoint_completion_target = '0.9';
ALTER SYSTEM SET work_mem = '128MB';
ALTER SYSTEM SET max_wal_size = '8GB';
/* ALTER USER SET */
ALTER USER <username> SET work_mem TO '128MB';

/* pg_settings */
select name, setting from pg_settings where name like '%ssl%'
select name, setting from pg_settings where name like '%work_mem%'

-- Создание бд
create user nsi with login password 'nsi!';
create database nsi owner nsi;
grant create, connect, temporary on database nsi to nsi;
alter role nsi set search_path to nsi;

-- Сиквенсы
truncate table tbl_sessions_count;
select setval('tbl_sessions_count_id_seq', 1, false);

-- Пересоздание схемы
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
COMMENT ON SCHEMA public IS 'standard public schema';

-- Disable the constraints
ALTER TABLE reference DISABLE TRIGGER ALL;
ALTER TABLE reference ENABLE TRIGGER ALL;

-- Список таблиц
select t.table_schema, t.table_name
from information_schema.tables t
where t.table_schema = 'era_mer'
and t.table_type = 'BASE TABLE' 

-- Список отключенных триггеров
SELECT
	pg_trigger.*
FROM
	pg_trigger,
	pg_class,
	pg_tables
WHERE tgrelid = relfilenode
AND relname = tablename
and tgenabled = 'D'

-- generate_series(1,1) - одна строка
select date_trunc('day', CURRENT_TIMESTAMP) from generate_series(1,1);
--2016-02-09 13:00:00+05
SELECT date_trunc('hour', TIMESTAMP '2016-02-17 20:38:40') from generate_series(1,1);
--2016-02-17 20:00:00

-- RETURNING (* - возвращает всю строку) аналог ROWID - CTID
insert into measure_accuracy values (222, 'BY1001', 1, 1, 1, 1) RETURNING *
update measure_accuracy set value_begin =123 where id = 222 RETURNING *

-- start time PostgreSQL:
select pg_postmaster_start_time();
-- uptime:
select now() - pg_postmaster_start_time();

/* количество сессий */
select application_name, count(*) as cnt from pg_stat_activity t
 group by t.application_name
 order by cnt desc;

/* медленные или зависшие запросы, которые выполняются в данный момент */
select pid, client_addr, usename, datname, state, to_char(current_timestamp - state_change, 'ssss.ms') as runtime, query, application_name
from pg_stat_activity 
where pid <> pg_backend_pid() 
and state = 'active' 
and state_change < current_timestamp - interval '3' second
order by runtime desc;

/* топ запросов, занимающих много времени */
select query,
  round(total_time::numeric, 2) as total_time,
  calls,
  round(mean_time::numeric, 2) as mean,
  round((100 * total_time / sum(total_time::numeric) over ())::numeric, 2) as percentage_cpu
from  pg_stat_statements
order by total_time desc
limit 30;

/* топ запросов, занимающих много времени */
SELECT 
  pss.userid,
  pss.dbid,
  pd.datname as db_name,
  round(pss.total_time::numeric, 2) as total_time, 
  pss.calls, 
  round(pss.mean_time::numeric, 2) as mean, 
  round((100 * pss.total_time / sum(pss.total_time::numeric) OVER ())::numeric, 2) as cpu_portion_pctg,
  pss.query
FROM pg_stat_statements pss, pg_database pd
WHERE pd.oid=pss.dbid
ORDER BY pss.total_time 
DESC LIMIT 30;

/* vacuum (verbose, analyze) */
select format('vacuum (verbose, analyze) %I.%I;', table_schema, table_name)
  from information_schema.tables
where table_schema = 'era_neuro'
   and table_type = 'BASE TABLE'
   and table_name not like '%202%'

/* last vacuum */
select relname,last_vacuum, last_autovacuum, last_analyze, last_autoanalyze 
from pg_stat_user_tables

