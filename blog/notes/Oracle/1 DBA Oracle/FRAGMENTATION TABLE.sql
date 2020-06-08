/*
������� ��������������:
1. drop and recreate (exp/imp)
2. truncate (exp the data, truncate it, imp the data)
3. alter TABLE move + rebuild indexes
4. SHRINK SPACE ��������� � 10G
5. DBMS_REDEFINITION
*/

--������������ �������
SELECT TABLE_NAME, ROUND((BLOCKS*8),2) "SIZE_KB",
ROUND((NUM_ROWS*AVG_ROW_LEN/1024),2) "SIZEREAL_KB",
ROUND((BLOCKS*8),2)-ROUND((NUM_ROWS*AVG_ROW_LEN/1024),2) "RECLAIMABLE_SPACE",
ROUND((ROUND((BLOCKS*8),2)-ROUND((NUM_ROWS*AVG_ROW_LEN/1024),2))*100/DECODE(ROUND((BLOCKS*8),2), 0, 1, ROUND((BLOCKS*8),2)), 2) "PERC"
FROM ALL_TABLES
WHERE TABLE_NAME = upper('ZREPL_TRANSFER');

--���������� ����������� �������:
ALTER INDEX test_idx REBUILD ONLINE;

--����������������� ������� � ���������� ������
ALTER INDEX test_idx COALESCE;

--�������������� alter TABLE move + rebuild indexes + GATHER_TABLE_STATS
declare
sTABLE varchar2(100);
begin
sTABLE:='ZREPL_MSG_I';
execute immediate 'ALTER TABLE '||sTABLE||' MOVE';  
begin
for cur_indx in (SELECT STATUS, INDEX_NAME FROM USER_INDEXES WHERE TABLE_NAME = sTABLE)
loop
  execute immediate 'ALTER INDEX '||cur_indx.INDEX_NAME||' REBUILD';
  end loop;
end;
begin
DBMS_STATS.GATHER_TABLE_STATS(user,sTABLE);
end;
end;


-- ��� ������� ��� ��������������� ������ 10�� � ����� 50%
SELECT T.* FROM (
SELECT TABLE_NAME, ROUND((BLOCKS*8),2) "SIZE_KB",
ROUND((NUM_ROWS*AVG_ROW_LEN/1024),2) "SIZEREAL_KB",
ROUND((BLOCKS*8),2)-ROUND((NUM_ROWS*AVG_ROW_LEN/1024),2) "RECLAIMABLE_SPACE",
ROUND((ROUND((BLOCKS*8),2)-ROUND((NUM_ROWS*AVG_ROW_LEN/1024),2))*100/DECODE(ROUND((BLOCKS*8),2), 0, 1, ROUND((BLOCKS*8),2)), 2) "PERC"
FROM USER_TABLES) T 
WHERE T.RECLAIMABLE_SPACE>10000
AND T.PERC>50


/* ����������� ������� ������� */
begin
for cur_indx in (SELECT STATUS, INDEX_NAME FROM USER_INDEXES WHERE TABLE_NAME = 'SHIFT_REPORT_DISP')
loop
begin
  execute immediate 'ALTER INDEX '||cur_indx.INDEX_NAME||' REBUILD';
exception then others then
dbms_output.
  end;
  end loop;
end;

--���� ���������� ��� �������
begin
DBMS_STATS.GATHER_TABLE_STATS('LIDER','CARD_GDS_FLOW');
end;
-- ��� �������
begin
DBMS_STATS.GATHER_INDEX_STATS('LIDER','STORAGE_GOODS_PK');
end;

--���������� ������ � ����� ����������
select * from DBA_TAB_STATISTICS t where t.table_name = 'CARD_GDS_FLOW';
-- ��� �������
select * from SYS.DBA_IND_STATISTICS t where t.INDEX_NAME='STORAGE_GOODS_PK'
