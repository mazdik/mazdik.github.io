--performance tuning

--Установка режима оптимизатора (OPTIMIZER_MODE)
--Сбор статистических данных (DBMS_STATS)
--Оптимизация SQL-запросов (Cost-Based Optimizer - CBO)
--Использование индексов (index)
--Использование подсказок для оказания влияния на план выполнения (hints)
--Использование секционированных таблиц (partitioned tables)
--Применение технологий сжатия (table compress)
--Использование материализованных представлений (materialized views) 
--Использование хранимых планов запроса(Stored Outlines, SQL Profiles, SQL patch, SQL plan baseline)
--Применение опции параллельного выполнения (PARALLEL)
--Использование кэша результатов

/*
Установка режима оптимизатора
OPTIMIZER_MODE
Параметр OPTIMIZER_MODE определяет тип оптимизации, которому должен соответствовать оптимизатор запросов Oracle. 
all_rows (по умолчанию)
first_rows_n (где n= 1, 10, 100 или 1000).
first_rows (Oracle рекомендует использовать first_rows_n)
*/
ALTER SESSION SET OPTIMIZER_MODE = first_rows_10;
SELECT name, value FROM V$PARAMETER WHERE name = 'optimizer_mode';

--Сбор статистических данных
DBMS_STATS.GATHER_DATABASE_STATS(ESTIMATE_PERCENT => NULL, METHOD_OPT =>'FOR ALL COLUMNS SIZE AUTO', GRANULARITY => 'ALL', CASCADE => 'TRUE', OPTIONS => 'GATHER AUTO');
DBMS_STATS.GATHER_SCHEMA_STATS(OWNNAME => 'LIDER');
DBMS_STATS.GATHER_TABLE_STATS('LIDER','CHEQUE');
DBMS_STATS.GATHER_INDEX_STATS('LIDER','STORAGE_GOODS_PK');
DBMS_STATS.GATHER_DATABASE_STATS_JOB_PROC;

--Сбор статистических данных по системе
DBMS_STATS.GATHER_SYSTEM_STATS('START');
DBMS_STATS.GATHER_SYSTEM_STATS('STOP');
SELECT * FROM SYS.AUX_STATS$;

--когда таблица анализировалась в последний раз
select t.TABLE_NAME, t.LAST_ANALYZED from DBA_TABLES t where t.TABLE_NAME IN ('CHEQUE');
--статистические данные
SELECT * FROM DBA_TAB_STATISTICS;
SELECT * FROM DBA_TAB_COL_STATISTICS;
--статистические данные устарели или нет
SELECT * FROM DBA_TAB_MODIFICATIONS;

/*
Оптимизатор по стоимости (Cost-Base Optimizer — CBO)
CBO выбирает тот, который является наименьшим по стоимости.
- Соединение с вложенным циклом(nested loop join)
- Хеш-соединение(hash join)
- Соединение типа сортировка-слияние(sort-merge join)
*/

--Optimizer Hints
--Вложенные  циклы
SELECT /*+ USE_NL (TableA, TableB) */
--Хеш-соединение
SELECT /*+ USE_HASH */
--Соединение слиянием
SELECT /*+ USE_MERGE (TableA, TableB) */

/*
Слишком большое количество индексов замедляет выполнение DML-операций. 
Каждая DML-операция подразумевает внесение изменений как в саму таблицу, так и в ее индексы.
Каждый оператор INSERT, UPDATE и DELETE приводит к внесению изменений в лежащие в основе таблицы индексы, что в 
некоторых случаях вполне может замедлять работу всего приложения.
*/

--Оптимизация использования библиотечного кэша
CURSOR_SHARING
CURSOR_SPACE_FOR_TIME
SESSION_CACHED_CURSORS

/* 
Oracle 11g повышения производительности PL/SQL-кода
http://www.fors.ru/upload/magazine/01/html_texts/w_adm_oracle11g_nanda07.html
http://www.foxbase.ru/oracle-programming/plsql-11g-native-compilation.htm
http://www.foxbase.ru/oracle-programming/oracle-plsql-intra-unit-inlining.htm

*/
/* native compilation (встроенная компиляция) */
--Увидеть, какие PL/SQL объекты в каком режиме откомпилированы, можно выполнив запрос:
SELECT * FROM user_stored_settings WHERE param_name = 'plsql_compiler_flags';
--установить параметр сессии перед созданием или перекомпиляцией хранимого кода:
alter session set plsql_code_type = native;
--В итоге на production базах данных желательно использовать Native Compilation, как говорится, хуже не будет.
--Native Compilation происходит несколько дольше, чем в обычном режиме Interpreted Compilation.

/* intra-unit inlining (внутримодульное замещение вызова) */
--Увидеть, с каким уровнем оптимизации скомпилирован:
SELECT name, plsql_optimize_level FROM user_plsql_object_settings;
--установить параметр сессии перед созданием или перекомпиляцией хранимого кода:
ALTER SESSION SET plsql_optimize_level = 3;
