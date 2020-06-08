/* 
������ ����� � ������� � ��������� ����������� ����� ����� ������ �������� ����� �������?
���� � ������� �����-�� ���� ������� ���������� �����, ����� ����� �����������, ������ ��� Oracle ������ ����������� ������ ����, 
� ������� �����-���� ����������� ������ � ������ �� ������� ������������� ���������� ������� (High Water Mark � HWM).
������� �������� �������:
1. drop and recreate (exp/imp)
2. truncate (exp the data, truncate it, imp the data)
3. alter TABLE move + rebuild indexes
4. SHRINK SPACE ��������� � 10G
5. DBMS_REDEFINITION
ALTER TABLE ���_������� SHRINK SPACE [COMPACT] [CASCADE];
������� ���� ������� ��� ����� �������� � �������������� ������� � ���������� �� �����. 
����� HWM �������������� � ����� ������� ������� � ����������� ��������������� ������������.
����� COMPACT �������� ��������������, �� �� ������������ HWM.
����� CASCADE ������� �� ������ ��������� �������, �� � ����� ��������� �������, ��������, �������.
��������� ������������ ������ ����� ����� ����� ROWID, 
�� ������ ��������� ����� ��������, ������� ����������� �� ��������� ROWID, ��� ��� ����� ��������� ��������.
������� ����� � ������ �����������: ������������������� � ������������.
*/

--������ ������ ������� ��
select round(bytes /1024/1024, 2) mb
from   dba_segments
WHERE segment_name = upper('zrepl_msg_i');

alter table zrepl_msg_i enable row movement;
ALTER TABLE zrepl_msg_i SHRINK SPACE;
alter table zrepl_msg_i disable row movement;

--������ ������ ������� �����
select round(bytes /1024/1024, 2) mb
from   dba_segments
WHERE segment_name = upper('zrepl_msg_i');
