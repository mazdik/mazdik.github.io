--FORCE LOGGING
--���� ����� ����� ��� �������������� ������ ���������� � redo logs ���� ��� ��������, ����������� � ������ NOLOGGING.
--������ ������������ � Data Guard (standby databases)

--������ ������� ��:
select log_mode, force_logging from V$DATABASE

--��������:
ALTER DATABASE force logging;
ALTER TABLESPACE users FORCE LOGGING;

--���������:
ALTER DATABASE no force logging;
ALTER TABLESPACE users NO FORCE LOGGING;


--LOGGING
select tablespace_name, logging, status from dba_tablespaces

select owner, tablespace_name, logging, count(*) from DBA_TABLES
group by owner, tablespace_name, logging
order by logging, owner


--NOLOGGING 
--��� ���������� ������ � redo logs .

ALTER TABLE t1 NOLOGGING;

ALTER TABLE t1 LOGGING;