-- ��������� �����
select group#, bytes, status from v$log;

    GROUP#      BYTES STATUS
---------- ---------- ----------------
         1   52428800 ACTIVE
         2   52428800 ACTIVE
         3   52428800 CURRENT
		 
-- ����� redo �����.
select group#, member from v$logfile;

    GROUP# MEMBER
---------- ----------------------------------------
         3 I:\MTSZN\REDO03.LOG
         2 I:\MTSZN\REDO02.LOG
         1 I:\MTSZN\REDO01.LOG
		 
-- �������� ����� ������ ����� �� 100M
alter database add logfile group 4 'I:\MTSZN\REDO04.LOG' size 100M;
alter database add logfile group 5 'I:\MTSZN\REDO05.LOG' size 100M;
alter database add logfile group 6 'I:\MTSZN\REDO06.LOG' size 100M;


-- ����� �������� ��� ��� �� ����� ��������� �����.
alter system switch logfile;

-- ������� ������ ����
alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;


ERROR at line 1:
ORA-01624: log 3 needed for crash recovery of instance oradb (thread 1)
ORA-00312: online log 3 thread 1: 'I:\MTSZN\REDO03.LOG'
-- ��� �������� ���������� ���� ��� ��� ��������� ��������, ����� ������� ��� ����������, 
-- �.�. ������ �� ���� ��� �� �������� � ����� ������. ������� ��� ������������� ����� ��������
alter system checkpoint;
-- ����� ���� ����� ��������� �������.
alter database drop logfile group 3;

-- ������ ����� ������� ������ ����� ������������ �������.
D:\> del I:\MTSZN\REDO01.LOG
D:\> del I:\MTSZN\REDO02.LOG
D:\> del I:\MTSZN\REDO03.LOG  

-- ��� ���������� � ������������ ������
ALTER DATABASE ADD LOGFILE MEMBER 'I:\MTSZN\REDO07.LOG' TO GROUP 4;

-- �������� ����� ������
ALTER DATABASE DROP LOGFILE MEMBER 'I:\MTSZN\REDO07.LOG';

-- ��������������
ALTER DATABASE RENAME FILE 'C:\MTSZN\REDO1.LOG' TO 'I:\MTSZN\REDO1.LOG';

