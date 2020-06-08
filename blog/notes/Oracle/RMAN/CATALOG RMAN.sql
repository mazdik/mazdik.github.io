--���
CREATE TABLESPACE RMAN_TBS DATAFILE 'D:\app\oradata\apex\rman_tbs01.dbf' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

--�������� ����� �������� ��������������
CREATE USER RMAN IDENTIFIED BY rman
  TEMPORARY TABLESPACE temp
  DEFAULT TABLESPACE RMAN_TBS
  QUOTA UNLIMITED ON RMAN_TBS

--������ ����������� ����������
GRANT RECOVERY_CATALOG_OWNER TO rman;

--����������� � RMAN
rman catalog rman/rman@apex target rman/rman@apex 

--�������� �������� ��������������
RMAN> CREATE CATALOG;

--����������� ���� ������
RMAN> REGISTER DATABASE;

--��������������� ��������
RMAN> RESYNC CATALOG;

--�������� ��������
RMAN> DROP CATALOG;

--����� ������ ����� ��-������ ��������������
SQL> SELECT * FROM rcver;
