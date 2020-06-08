--узнать кодировку бд oracle
SELECT * FROM NLS_DATABASE_PARAMETERS;

RUSSIAN_RUSSIA.CL8MSWIN1251
AMERICAN_AMERICA.CL8MSWIN1251

--кодировка сессии
set NLS_LANG=RUSSIAN_CIS.CL8MSWIN1251

--узнать текущую кодировку
echo $NLS_LANG

--Oracle 12
RUSSIAN_CIS.RU8PC866

ALTER SESSION SET NLS_LANGUAGE='RUSSIAN';

alter session set nls_numeric_characters='.,';
--результат: 18.5
alter session set nls_numeric_characters=',.';
select to_char(sr.temperature, '99G999D99', 'NLS_NUMERIC_CHARACTERS = '',.''') from dual
--результат: 18,50
select rtrim(to_char(.55, 'FM999999999999990D99999999999999', 'NLS_NUMERIC_CHARACTERS = '',.'''), ',') from dual
-- 0,55

/* NLS */
NLS_LANG					AMERICAN_AMERICA.CL8MSWIN1251
NLS_NUMERIC_CHARACTERS		.,
ORACLE_HOME					C:\oracle\instant
TNS_ADMIN					C:\oracle\instant

/* Смена кодировки бд (делали на XE) */
CONNECT / AS SYSDBA;
ALTER SYSTEM ENABLE RESTRICTED SESSION;
ALTER DATABASE CHARACTER SET INTERNAL_USE CL8MSWIN1251;
SHUTDOWN;
STARTUP;

STARTUP MOUNT;
ALTER SYSTEM ENABLE RESTRICTED SESSION;
ALTER DATABASE OPEN;
ALTER DATABASE CHARACTER SET AL32UTF8;
SHUTDOWN IMMEDIATE;
STARTUP;

