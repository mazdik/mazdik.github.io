select * from DBA_DATA_FILES t

--Добавляем дата-файл к тейблспейсу:
ALTER TABLESPACE PARUS_MAIN ADD DATAFILE 'D:\FRS\PARUS_MAIN2.DAT' SIZE 1G autoextend on next 64M maxsize unlimited;
ALTER TABLESPACE AUDIT_KERNEL ADD DATAFILE 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\AUDIT02.DBF' SIZE 512M  autoextend on next 64M maxsize unlimited;

--alter datafile
ALTER DATABASE DATAFILE 'D:\app\oradata\apex\APEX_2204620394396539.DBF' autoextend on next 10M maxsize unlimited;

--resize
alter database datafile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\TOOLS01.DBF' resize 50M;
alter database datafile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\TOOLS01.DBF' autoextend on next 10M maxsize 2G;

--temp
alter database tempfile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\TEMP01.DBF' resize 1G;
alter database tempfile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\TEMP01.DBF' autoextend on next 10M maxsize 1G;

--drop tablespace
DROP TABLESPACE XDB INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;

--create tablespace
CREATE TABLESPACE REPL DATAFILE 'D:\app\oradata\SIM\REPL01.DBF' SIZE 128 REUSE AUTOEXTEND ON NEXT 32M maxsize unlimited;
CREATE TABLESPACE IDX DATAFILE 'D:\app\oradata\SIM\IDX01.DBF' SIZE 128 REUSE AUTOEXTEND ON NEXT 32M maxsize unlimited;
