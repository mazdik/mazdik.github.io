/*
Уровни Flashback
1. Уровень строк
Flashback Query (функция ретроспективного запроса)
Flashback Versions Query (функция ретроспективного запроса версий строки)
Flashback Transaction Query (функция ретроспективного запроса транзакций)
Flashback Transaction Backout (функция ретроспективной отмены транзакций)
2. Уровень таблиц
Flashback Table (функция ретроспективного отката таблицы)
Flashback Drop (функция ретроспективного отката удаления)
3. Уровень базы данных
Flashback Database (функция ретроспективного отката базы данных)

Еще, однако, существует механизм Flashback Data Archive (Архив ретроспективных данных)
*/
--------------------- Flashback Database ---------------------

SELECT flashback_on FROM v$database;

--Включаем FlashBack database
shutdown immediate;
startup mount;
ALTER DATABASE FLASHBACK ON;
alter database open;

--Выкл FlashBack database
ALTER DATABASE FLASHBACK OFF;

--для табличных пространств
ALTER TABLESPACE users FLASHBACK OFF;
ALTER TABLESPACE users FLASHBACK ON;

--макс число минут на которое можно возвратиться в прошлое. 720минут=12часов 
ALTER SYSTEM SET DB_FLASHBACK_RETENTION_TARGET=720 SCOPE=BOTH;

--выполнение ретроспективного отката базы данных до состояния, в котором она находилась час назад
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
FLASHBACK DATABASE TO TIMESTAMP(SYSDATE -1/24);
--FLASHBACK DATABASE TO SCN 5964663;
--FLASHBACK DATABASE TO SEQUENCE 12345;
--ALTER DATABASE OPEN READ ONLY; --перед RESETLOGS не помешает сначала проверить данные
ALTER DATABASE OPEN RESETLOGS;
-- В случае если состояние базы данных после проведения операции Flashback Database по какой-то причине не понравится,
-- с помощью приведенной ниже команды можно отменить результат всей операции Flashback. Приведет базу данных в актуальное состояние.
RECOVER DATABASE;

--точки восстановления
CREATE RESTORE POINT test;
CREATE RESTORE POINT test_guarantee GUARANTEE FLASHBACK DATABASE;
DROP RESTORE POINT test;
FLASHBACK DATABASE TO RESTORE POINT test_guarantee;
--Просмотр точек восстановления
SELECT name, scn, storage_size, time, guarantee_flashback_database FROM V$RESTORE_POINT;

--------------------- Flashback Query ---------------------
--зависит от undo_retention (по умаолчанию 900 - 15мин)

--10 минут назад, когда удаленная строка все еще существовала: 
SELECT * FROM emp 
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE) 
WHERE empno = 7934;

-- 2 дня назад
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '2' DAY)

--вставить обратно удаленную строку
INSERT INTO employees
SELECT * FROM employees AS OF TIMESTAMP
TO_TIMESTAMP('2008-09-02 08:00:00', 'YYYY-MM-DD HH:MI:SS')
WHERE last_name = 'Alapati';

/* Откат. Выполнять только 1 раз, после инсерта у строки будет новый ROWID 
или create table во временную таблицу
*/
insert into DOB
SELECT * FROM DOB
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE) 
WHERE ROWID NOT IN (select T.ROWID from DOB T)

--включить момент времени в прошлом
DBMS_FLASHBACK.ENABLE_AT_TIME (TO_TIMESTAMP '11-DEC-2008:10:00:00', 'DD-MON-YYYY:hh24:MI:SS');
--выполнить запросы и тд.
--отключить
DBMS_FLASHBACK.DISABLE ();

--------------------- Flashback Versions Query ---------------------
--хронология строки

SELECT versions_xid AS XID, versions_startscn AS START_SCN,
versions_endscn AS END_SCN,
versions_operation AS OPERATION,
empname FROM EMPLOYEES
VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE
AS OF SCN 7920
WHERE emp_id = 222;

--------------------- Flashback Transaction Query ---------------------
--вьюшка FLASHBACK_TRANSACTION_QUERY
--поле UNDO_SQL - содежит SQL, необходимые для отмены изменений
-- например если в OPERATION - insert, то в UNDO_SQL будет delete

SELECT operation, undo_sql, table_name FROM flashback_transaction_query

--------------------- Flashback Transaction Backout ---------------------
--можно выполнять откат транзакции, а также всех зависимых от нее транзакций, без перевода базы данных в автономный режим
--с помощью процедуры DBMS_FLASHBACK.TRANSACTION_BACKOUT
SELECT * FROM DBA_FLASHBACK_TRANSACTION_STATE; 
SELECT * FROM DBA_FLASHBACK_TRANSACTION_REPORT;
--Прежде чем использовать функцию Flashback Transaction Backout, нужно обязательно включить в базе данных дополнительную журнализацию:
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
--пример
declare
trans_arr xid_array;
begin
trans_arr := xid_array('030003000D02540','D10001000D02550');
dbms_flashback.transaction_backout (numtxns   => 1, xids => trans_arr, options   => dbms_flashback.nocascade);
end;

--------------------- Flashback Table ---------------------
ALTER TABLE emp ENABLE ROW MOVEMENT;

--возврат таблицы на один день
FLASHBACK TABLE emp to TIMESTAMP (SYDATE -1);

--текущий номер SCN базы данных
SELECT current_scn from V$DATABASE;
--Перед запуском операции Flashback Table важно всегда запоминать текущий номер SCN, чтобы при необходимости можно было отменить операцию повторным вызовом
FLASHBACK TABLE emp TO SCN 5759290864;

--------------------- Flashback Drop ---------------------
--Восстановление удаленной таблицы
FLASHBACK TABLE persons TO BEFORE DROP;
FLASHBACK TABLE "BIN$xTMPjHZ6SG+1xnDIaR9E+g==$0" TO BEFORE DROP RENAME TO NEW_PERSONS;
--корзина
SELECT * FROM DBA_RECYCLEBIN;

--------------------- Flashback Data Archive ---------------------
--Создание архива
CREATE FLASHBACK ARCHIVE flash1
TABLESPACE test_tbs
RETENTION 1 YEAR;
--Удаление архива
DROP FLASHBACK ARCHIVE flash1;
--Просмотр данных архива
SELECT * FROM DBA_FLASHBACK_ARCHIVE;
SELECT * FROM DBA_FLASHBACK_ARCHIVE_TS;
SELECT * FROM DBA_FLASHBACK_ARCHIVE_TABLES;
--Включение/Отключение архива
ALTER TABLE employee FLASHBACK ARCHIVE flash1;
ALTER TABLE employee NO FLASHBACK ARCHIVE;
--Получение доступа к хронологическим данным AS_OF
select * from patient_info as of timestamp to_timestamp ('2009-01-01 00:00:00', 'YYYY-MM-DD HH23:MI:SS');
--systimestamp — interval '60' second
--systimestamp — interval '7' day
--systimestamp — interval '12' month
--выбирались за период VERSIONS BETWEEN TIMESTAMP
SELECT * FROM patient_info VERSIONS BETWEEN TIMESTAMP to_timestamp('2009-01-01 00:00:00','YYYY-MM-DD HH23:MI:SS') AND MAXVALUE;

