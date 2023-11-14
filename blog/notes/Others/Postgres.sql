--Консоль
sudo -u postgres psql postgres
\l : list all databases
\du : list all users
\connect DBNAME

show max_connections;
show shared_buffers;

sudo service postgrespro-std-12.service restart

-- pg_hba.conf
host    all    all    0.0.0.0/0    md5

-- Сиквенсы
truncate table tbl_sessions_count;
SELECT setval('tbl_sessions_count_id_seq', 1, false);

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

-- DUMP
pg_dump -U postgres -f postgres.sql
--Восстановление 
psql -U postgres -d postgres -f postgres.sql
psql -U era_mer -d era_mer -f postgres.sql

-- Создание бд
CREATE ROLE era_mer WITH LOGIN PASSWORD 'era_mer';
CREATE TABLESPACE era_mer OWNER era_mer LOCATION '/home/postgres/era_mer';
CREATE DATABASE era_mer OWNER era_mer TABLESPACE era_mer;
GRANT ALL ON DATABASE era_mer TO era_mer;
REVOKE ALL ON DATABASE era_mer FROM public;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA era_mer TO era_mer;

-- RETURNING (* - возвращает всю строку) аналог ROWID - CTID
insert into measure_accuracy values (222, 'BY1001', 1, 1, 1, 1) RETURNING *
update measure_accuracy set value_begin =123 where id = 222 RETURNING *

-- How to set some context variable for a user/connection
set myvars.language_id = 10;
show myvars.language_id;
-- or via functions
select set_config('myvars.language_id', '20', false);
select current_setting('myvars.language_id');

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
