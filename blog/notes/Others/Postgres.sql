--Консоль
psql -h localhost -p 5432 -U postgres -W postgres
psql -U postgres
\connect DBNAME
\q
psql -U postgres -d postgres -f 136_output_table.sql

--Сиквенсы
truncate table tbl_sessions_count;
SELECT setval('tbl_sessions_count_id_seq', 1, false);

--Пересоздание схемы
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
COMMENT ON SCHEMA public IS 'standard public schema';

-- UPSERT
INSERT INTO tablename (a, b, c) values (1, 2, 10)
ON CONFLICT (a) DO UPDATE SET c = EXCLUDED.c + 1;
--
INSERT INTO {t} (id,col1, col2, col3)
	VALUES (%s, %s, %s, %s)
	ON CONFLICT (id)
	DO UPDATE SET
		(col1, col2, col3)
	  = (EXCLUDED.col1, EXCLUDED.col2, EXCLUDED.col3)

-- Disable the constraints
ALTER TABLE reference DISABLE TRIGGER ALL;
ALTER TABLE reference ENABLE TRIGGER ALL;

-- ограничения откладываются до фиксации транзакции
SET CONSTRAINTS ALL DEFERRED

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

-- DUAL
create view DUAL as select 'X'::text as DUMMY

--SYSDATE
SELECT current_date, current_timestamp 

-- DUMP
pg_dump -U postgres -f postgres.sql
--Восстановление 
psql -U postgres -d postgres -f postgres.sql
psql -U era_mer -d era_mer -f postgres.sql
"C:\Program Files\PostgreSQL\10\bin\psql.exe" -U postgres -d postgres -f postgres.sql

-- Comments columns
select t1.table_name, t1.column_name, t1.data_type, pgd.description as comments
  from (select c.table_name, c.column_name, c.data_type, c.ordinal_position, st.relid
          from pg_catalog.pg_statio_all_tables st, information_schema.columns c
         where c.table_schema = st.schemaname
           and c.table_name = st.relname
           and c.table_name = 'name_translation') t1
  left outer join pg_catalog.pg_description pgd
    on pgd.objoid = t1.relid
   and pgd.objsubid = t1.ordinal_position

-- Отличия substr
Oracle substr('abcdefg', 1, 4) = 'abcd'
Oracle substr('abcdefg', 0, 4) = 'abcd'
Oracle substr('abcdefg', -1, 4) = 'd'
PG substr('abcdefg', 1, 4) = 'abcd'
PG substr('abcdefg', 0, 4) = 'abc'
PG substr('abcdefg', -1, 4) = 'ab'

-- ENABLE / DISABLE ALL TRIGGERS
CREATE OR REPLACE FUNCTION disable_triggers(a boolean, nsp character varying)
  RETURNS void AS
$BODY$
declare 
act character varying;
r record;
begin
    if(a is true) then
        act = 'disable';
    else
        act = 'enable';
    end if;

    for r in select c.relname from pg_namespace n
        join pg_class c on c.relnamespace = n.oid and c.relhastriggers = true
        where n.nspname = nsp
    loop
        execute format('alter table %I.%I %s trigger all', nsp,r.relname, act); 
    end loop;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION disable_triggers(boolean, character varying)
  OWNER TO postgres;
--
SELECT disable_triggers(true,'public');

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

