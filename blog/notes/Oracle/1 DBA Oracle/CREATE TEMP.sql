--������ DEFAULT_TEMP_TABLESPACE
SELECT PROPERTY_NAME, PROPERTY_VALUE 
FROM DATABASE_PROPERTIES;
--������� temp-����
DROP TABLESPACE PARUS_TEMP INCLUDING CONTENTS AND DATAFILES;
--2������� ��������. ������ ���� ���� ��������� �������
alter database tempfile 'D:\FRS\PARUS_TEMP.DAT' drop;
--������� temp-����
alter tablespace PARUS_TEMP add tempfile 'D:\FRS\PARUS_TEMP.DAT' size 1000M reuse autoextend on next 10M;
--������� �� ���������
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE PARUS_TEMP;

--�������� ���������� ���������� ������������ ��� ���� �������������
SELECT USERNAME, TEMPORARY_TABLESPACE, ACCOUNT_STATUS FROM DBA_USERS;
--���������� ������������ TEST
ALTER USER TEST TEMPORARY TABLESPACE PARUS_TEMP;


--ORA-01652: unable to extend temp segment by 128 in tablespace TEMP
SELECT file_name, bytes, status, autoextensible FROM dba_temp_files
--autoextensible=NO 
alter database tempfile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\TEMP01.DBF' autoextend on next 10M maxsize 2G;
alter database tempfile 'D:\ORACLE\PRODUCT\10.2.0\ORADATA\ORCL\TEMP01.DBF' resize 1G;

--����������� ���� �����
select * from SYS.V_$TEMPFILE