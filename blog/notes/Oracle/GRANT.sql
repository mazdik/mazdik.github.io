--���������� 2 �������� ���� ���������� Oracle: ��������� � ���������

--���������
GRANT CREATE SESSION TO hr;
REVOKE DELETE ANY TABLE FROM pasowner;

--���������
GRANT DELETE ON bonuses TO hr;
--�� ������ �������
GRANT UPDATE (product_id) ON sales01 TO salapati;
REVOKE UPDATE ON ods_process FROM tester;

--����
CREATE ROLE new_dba;
CREATE ROLE clerk IDENTIFIED BY password;
GRANT CONNECT TO new_dba;
GRANT new_dba TO salapati;
DROP ROLE new_dba;

/*
DBA_USERS ������������� ���������� � �������������.
DBA_ROLES ���������� ��� ���� � ���� ������.
DBA_COL_PRIVS ���������� ����������, ��������������� �� ������ ��������.
DBA_ROLE_PRIVS ���������� ������������� � �� ����.
DBA_SYS_PRIVS ���������� �������������, ������� ������������� ��������� ����������.
DBA_TAB_PRIVS ���������� ������������� � �� ���������� � ��������.
ROLE_ROLE_PRIVS ���������� ����, ��������������� �����.
ROLE_SYS_PRIVS ���������� ��������� ����, ��������������� �����.
ROLE_TAB_PRIVS ���������� ��������� ����������, ��������������� �����.
SESSION_PRIVS ���������� ����������, ������� � ������ ������ �������� ��� �������� ������.
SESSION_ROLES ���������� ����, ������� � ������ ������ �������� ��� ������-�� ������.
*/

grant execute on P_R_MOVE_DATA to WELLOP;
