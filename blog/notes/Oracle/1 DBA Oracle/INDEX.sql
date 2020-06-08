--drop/create
drop index I_ENV_LOCK_SESSION_UNIT;
create index I_ENV_LOCK_SESSION_UNIT on ENV_LOCK(SESSION_ID,UNITCODE);

--перенести индексы в другое табличное пространство.
ALTER INDEX C_STATECONTRACTS_PK REBUILD TABLESPACE PARUS_INDEX;

--UNUSABLE
alter index I_ENV_LOCK_SESSION_UNIT UNUSABLE;

--this setting does not disable error reporting for unusable indexes that are unique.
ALTER SESSION SET skip_unusable_indexes = TRUE;

--Онлайновая перестройка индекса:
ALTER INDEX test_idx REBUILD ONLINE;

--parallel
ALTER INDEX test_idx REBUILD PARALLEL 4 NOLOGGING;

--Перераспределение индекса в онлайновом режиме
ALTER INDEX test_idx COALESCE;

--REBUILD всех индексов таблицы(DOC_TTT- имя таблицы)
begin
for cur in (SELECT STATUS, INDEX_NAME FROM USER_INDEXES WHERE TABLE_NAME = 'DOC_TTT')
loop
  execute immediate 'ALTER INDEX '||cur.INDEX_NAME||' REBUILD';
  end loop;
end;

--Мониторинг индекса
ALTER INDEX p_key_sales MONITORING USAGE;
--Теперь запустите какие-нибудь запросы к таблице sales.
--Выкл. мониторинг
ALTER INDEX p_key_sales NOMONITORING USAGE;
--для определения того, использовался ли индекс p_key_sales
SELECT * FROM v$object_usage WHERE index_name='P_KEY_SALES'

/*
Специальные типы индексов
1) Битовые индексы(bitmap indexes)
CREATE BITMAP INDEX gender_idx ON employee(gender);

2) Индексы с реверсированным ключом
CREATE INDEX reverse_idx ON employee(emp_id) REVERSE;

3) Индексы со сжатым ключом
CREATE INDEX emp_indx1 ON employees(ename) COMPRESS 1;

4) Индексы на основе функций
CREATE INDEX lastname_idx ON employees(LOWER(l_name));

5) Секционированные  индексы
a) Глобальные  индексы
CREATE INDEX ticketsales_idx ON ticket_sales(month)
GLOBAL PARTITION BY range(month)
(PARTITION ticketsales1_idx VALUES LESS THAN (3)
PARTITION ticketsales1_idx VALUES LESS THAN (6)
PARTITION ticketsales2_idx VALUES LESS THAN (9)
PARTITION ticketsales3_idx VALUES LESS THAN (MAXVALUE)
b) Локальные индексы
CREATE INDEX ticket_no_idx ON
ticket_sales(ticket__no) LOCAL
TABLESPACE localidx_01;

6) Невидимые  индексы
CREATE INDEX test_idx ON test(tname) INVISIBLE;
ALTER INDEX test_idx INVISIBLE;
ALTER INDEX test_idx VISIBLE;
*/
