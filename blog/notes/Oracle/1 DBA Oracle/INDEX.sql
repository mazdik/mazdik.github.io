--drop/create
drop index I_ENV_LOCK_SESSION_UNIT;
create index I_ENV_LOCK_SESSION_UNIT on ENV_LOCK(SESSION_ID,UNITCODE);

--��������� ������� � ������ ��������� ������������.
ALTER INDEX C_STATECONTRACTS_PK REBUILD TABLESPACE PARUS_INDEX;

--UNUSABLE
alter index I_ENV_LOCK_SESSION_UNIT UNUSABLE;

--this setting does not disable error reporting for unusable indexes that are unique.
ALTER SESSION SET skip_unusable_indexes = TRUE;

--���������� ����������� �������:
ALTER INDEX test_idx REBUILD ONLINE;

--parallel
ALTER INDEX test_idx REBUILD PARALLEL 4 NOLOGGING;

--����������������� ������� � ���������� ������
ALTER INDEX test_idx COALESCE;

--REBUILD ���� �������� �������(DOC_TTT- ��� �������)
begin
for cur in (SELECT STATUS, INDEX_NAME FROM USER_INDEXES WHERE TABLE_NAME = 'DOC_TTT')
loop
  execute immediate 'ALTER INDEX '||cur.INDEX_NAME||' REBUILD';
  end loop;
end;

--���������� �������
ALTER INDEX p_key_sales MONITORING USAGE;
--������ ��������� �����-������ ������� � ������� sales.
--����. ����������
ALTER INDEX p_key_sales NOMONITORING USAGE;
--��� ����������� ����, ������������� �� ������ p_key_sales
SELECT * FROM v$object_usage WHERE index_name='P_KEY_SALES'

/*
����������� ���� ��������
1) ������� �������(bitmap indexes)
CREATE BITMAP INDEX gender_idx ON employee(gender);

2) ������� � ��������������� ������
CREATE INDEX reverse_idx ON employee(emp_id) REVERSE;

3) ������� �� ������ ������
CREATE INDEX emp_indx1 ON employees(ename) COMPRESS 1;

4) ������� �� ������ �������
CREATE INDEX lastname_idx ON employees(LOWER(l_name));

5) ����������������  �������
a) ����������  �������
CREATE INDEX ticketsales_idx ON ticket_sales(month)
GLOBAL PARTITION BY range(month)
(PARTITION ticketsales1_idx VALUES LESS THAN (3)
PARTITION ticketsales1_idx VALUES LESS THAN (6)
PARTITION ticketsales2_idx VALUES LESS THAN (9)
PARTITION ticketsales3_idx VALUES LESS THAN (MAXVALUE)
b) ��������� �������
CREATE INDEX ticket_no_idx ON
ticket_sales(ticket__no) LOCAL
TABLESPACE localidx_01;

6) ���������  �������
CREATE INDEX test_idx ON test(tname) INVISIBLE;
ALTER INDEX test_idx INVISIBLE;
ALTER INDEX test_idx VISIBLE;
*/
