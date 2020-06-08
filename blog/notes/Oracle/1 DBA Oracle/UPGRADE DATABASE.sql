SHUTDOWN IMMEDIATE
STARTUP UPGRADE

catupgrd.sql -- обновление
utlirp.sql -- преоброзование бд (x64-x32)
utlrp.sql -- компил инвалидов в бд

@C:\oracle\product\11.2\dbhome\RDBMS\ADMIN\utlirp.sql -- преоброзование бд (x64-x32)
@C:\oracle\product\11.2\dbhome\RDBMS\ADMIN\catupgrd.sql -- обновление бд
@C:\oracle\product\11.2\dbhome\RDBMS\ADMIN\catuppst.sql -- остальные обновления бд
@C:\oracle\product\11.2\dbhome\RDBMS\ADMIN\utlrp.sql -- компил инвалидов в бд


@D:\oracle\product\10.2.0\db_1\RDBMS\ADMIN\utlirp.sql -- преоброзование бд (x64-x32)
@D:\oracle\product\10.2.0\db_1\RDBMS\ADMIN\catupgrd.sql -- обновление до
@D:\oracle\product\10.2.0\db_1\RDBMS\ADMIN\utlrp.sql -- компил инвалидов в бд


--Анализ требований обновления (Pre-Upgrade Information Tool)
SPOOL upgrade_info.log
@D:\oracle\product\10.2.0\db_1\RDBMS\ADMIN\utlu102i.sql -- 10g
@C:\oracle\product\11.2\dbhome\RDBMS\ADMIN\utlu111i.sql	-- 11g
SPOOL OFF

--Результаты обновления
@D:\oracle\product\10.2.0\db_1\RDBMS\ADMIN\utlu102s.sql -- 10g
@C:\oracle\product\11.2\dbhome\RDBMS\ADMIN\utlu111s.sql	-- 11g


--Сколько скомпилировалось
select count(*) from utl_recomp_compiled;
--Сколько осталось компилировать
select count(*) from obj$ where status in (4, 5, 6);

--on Windows: 
set ORACLE_HOME=D:\oracle\product\10.2.0\db_1
echo %ORACLE_HOME% 

--Unix/Linux: 
export ORACLE_HOME=app/oracle/product/10.2.0/db_1
echo $ORACLE_HOME

--Возврат к старой версии
STARTUP DOWNGRADE
@catdwgrd.sql


 

