select name,value from v$parameter where name like 'AUDIT_TRAIL%';
/*
NONE. Отключает аудит бд.  NONE — значение, используемое по умолчанию.
OS. -Oracle будет сохранять записи аудита в файл операционной системы (журнал аудита операционной системы).
DB. - Oracle будет сохранять записи аудита в журнале аудита бд, доступном для просмотра в виде представления DBA_AUDIT_TRAIL(хранящемся в таблице SYS.AUD$).
DB, EXTENDED. - Oracle будет отправлять все записи аудита в журнал аудита бд (SYS.AUD$) и при этом будет заполнять столбцы SQLBIND и SQLTEXT CLOB.
*/
--Включить аудит:
ALTER SYSTEM SET AUDIT_TRAIL=db SCOPE=SPFILE;
SHUTDOWN IMMEDIATE
STARTUP
/*
WHENEVER SUCCESSFUL - чтобы запись в журнал производилась только в случае успешного выполнения
WHENEVER NOT SUCCESSFUL - неудачного выполнения
*/
--Аудит для таблицы: 
AUDIT INSERT, UPDATE ON LIDER.WRITE_DOWN;
--Выключить
NOAUDIT INSERT, UPDATE ON LIDER.WRITE_DOWN;
--Посмотреть включенные объекты:
SELECT * FROM DBA_OBJ_AUDIT_OPTS;
--Результаты аудита:
SELECT * FROM DBA_AUDIT_TRAIL t where t.obj_name ='WRITE_DOWN';

--аудит на неправильные логины
AUDIT CONNECT BY SESSION WHENEVER NOT SUCCESSFUL
--после чего можно смотреть эти самые логины
SELECT * FROM SYS.DBA_AUDIT_SESSION WHERE returncode != 0 
--
AUDIT SELECT TABLE, UPDATE TABLE, INSERT TABLE, DELETE TABLE BY LIDER BY ACCESS;
NOAUDIT SELECT TABLE, UPDATE TABLE, INSERT TABLE, DELETE TABLE BY LIDER;
SELECT * FROM DBA_STMT_AUDIT_OPTS;

/* отключает аудит всех операторов */
NOAUDIT ALL;
/* отключает аудит всех полномочий */
NOAUDIT ALL PRIVILEGES;
/* отключает аудит всех объектов */
NOAUDIT ALL ON DEFAULT;

--Представления
SELECT * FROM DBA_AUDIT_SESSION
SELECT * FROM DBA_AUDIT_STATEMENT
SELECT * FROM DBA_AUDIT_TRAIL
SELECT * FROM DBA_AUDIT_OBJECT
---
select * from DBA_AUDIT_TRAIL t where t.os_username='MazitovRadR' and t.action_name not in ('LOGON', 'LOGOFF', 'SET ROLE');
select * from DBA_AUDIT_STATEMENT where os_username='MazitovRadR';
select * from SYS.DBA_AUDIT_OBJECT t  where t.os_username='MazitovRadR'

--Перенос таблиц AUD$ и FGA_LOG$ в другое табличное пространство
--http://oracle-base.com/articles/11g/auditing-enhancements-11gr2.php
CREATE TABLESPACE audit_aux DATAFILE '/u01/app/oracle/oradata/DB11G/audit_aux01.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE 2G;
BEGIN
  DBMS_AUDIT_MGMT.set_audit_trail_location(
    audit_trail_type           => DBMS_AUDIT_MGMT.AUDIT_TRAIL_DB_STD,
    audit_trail_location_value => 'AUDIT_AUX');
END;
--проверить
SELECT table_name, tablespace_name
FROM   dba_tables
WHERE  table_name IN ('AUD$', 'FGA_LOG$')
ORDER BY table_name;
--The DBMS_AUDIT_MGMT package is installed by default in Oracle 11.2, and in patchsets 10.2.0.5

--Детальный аудит(fine-grained auditing — FGA)
EXECUTE DBMS_FGA.ADD_POLICY(
object_schema  => 'hr',
object_name  => 'emp',
policy_name  => 'chk_hr_emp',
audit_condition  => 'dept = ''SALES'' ',
audit_column  => 'salary',
statement_types  => 'insert,update,delete,select',
handler_schema => 'sec',
handler_module  => 'log_id',
enable  => TRUE);
/*
FGA подвергает аудиту любой оператор DML (INSERT, UPDATE, DELETE и SELECT) в таблице hr.emp, 
который обращается к столбцу salary любого сотрудника отдела продаж (SALES).
Будут регистрироваться в таблице SYS.FGA_LOG$ из табличного пространства System. Представление DBA_FGA_AUDIT_TRAIL строится на основе этой таблицы.
*/
--журналы FGA-аудита 
SELECT * FROM DBA_FGA_AUDIT_TRAIL
--сочетает в себе журналы как обычного, так и FGA-аудита
SELECT * FROM DBA_COMMON_AUDIT_TRAIL


