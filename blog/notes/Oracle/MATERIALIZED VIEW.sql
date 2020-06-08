--����������������� �������������
--��� ����� � �������� ������������������ ������������� ���������� ��������� ��������� 3 ����.

--1. ������ ����������� ����������.
GRANT CREATE MATERIALIZED VIEW TO salapati;
GRANT QUERY REWRITE TO salapati;

--2. ������� ������ ������������������ ������������� (����������� ������������� ����� ���������� FAST).
CREATE MATERIALIZED VIEW LOG ON products 
WITH SEQUENCE, ROWID
(prod_id, prod_name, prod_desc, prod_subcategory,
prod_subcategory_desc,
prod_category, prod_category_desc, prod_weight_class,
prod_unit_of_measure, prod_pack_size, supplier_id, prod_status,
prod_list_price, prod_min_price)
INCLUDING NEW VALUES;
/
CREATE MATERIALIZED VIEW LOG ON sales
WITH SEQUENCE, ROWID
(prod_id, cust_id, time_id, channel_id, promo_id,
quantity_sold, amount_sold)
INCLUDING NEW VALUES;

--3. ������� ����������������� �������������.
CREATE MATERIALIZED VIEW product_sales_mv
TABLESPACE test1
STORAGE (INITIAL 8k NEXT 8k PCTINCREASE 0)
BUILD IMMEDIATE
REFRESH FAST
ENABLE QUERY REWRITE
AS SELECT p.prod_name, SUM(s.amount_sold) AS dollar_sales,
COUNT(*) AS cnt, COUNT(s.amount_sold) AS cnt_amt
FROM sales s, products p
WHERE s.prod_id = p.prod_id GROUP BY p.prod_name;GROUP BY p.prod_name;

/*
BUILD IMMEDIATE ���������� ��������� ����������������� �������������; ��� ����� ������� �� ���������.
REFRESH FAST �������������, ��� ����������������� ������������� ������ ������������ ����� ���������� FAST
ENABLE QUERY REWRITE ��������, ��� ����������� Oracle ��������� ��������� ��� �������
*/

--Materialized views
SELECT * FROM DBA_MVIEWS
--Materialized view log
SELECT * FROM DBA_MVIEW_LOGS

--DBMS_MVIEW is a synonym for DBMS_SNAPSHOT.
truncate table OKS.PAD_MV
begin
DBMS_MVIEW.REFRESH('OKS.PAD_MV');
end;
--- C-complete refresh, F-fast refresh, ?-force refresh, A-always refresh
begin
DBMS_SNAPSHOT.REFRESH( 'OKS.PAD_MV','C');
end;

/* ���. ������ ����������� ��������� (COMPLETE) ������ 5 �����
(�� ���� ��������� ���������, ����� ������������ REFRESH FAST ����� ����) */
CREATE MATERIALIZED VIEW TEMP_MV
REFRESH COMPLETE START WITH (SYSDATE) NEXT (SYSDATE+5/1440) WITH ROWID
AS SELECT * FROM TEMP;

/* ������������ ����������� ���. ������ */
CREATE MATERIALIZED VIEW LOG ON TEMP
   WITH ROWID
   INCLUDING NEW VALUES;
CREATE MATERIALIZED VIEW TEMP_MV 
   REFRESH FAST NEXT sysdate + 7 WITH ROWID
   AS SELECT * FROM TEMP;
   
/* ������� ����������������� ������������� */
DROP MATERIALIZED VIEW TEMP_MV;
/* ������� ������ ������������������ ������������� */
DROP MATERIALIZED VIEW LOG ON TEMP;

/* �������������� ���������� (Truncate DDL, Parallel DML) */
DBMS_MVIEW.REFRESH(LIST => 'MV_BASE_TABLE', METHOD => 'C', ATOMIC_REFRESH => FALSE);

/*
����� ����������
ON COMMIT. � ���� ������ ��� ������ �������� ����������� �������������.
ON DEMAND. � ���� ������ ��� ���������� ����������� ��������� ��������� ���� DBMS_MVIEW.REFRESH.
�� ��������� ����������� ����� ON DEMAND

��� ����������
COMPLETE. ��� ����� ���������� ���������.
FAST REFRESH. ��� �������� ���������� ���������� ������.
FORCE. Oracle ���������� ��������� ������� ���������� (fast refresh). ���� �� ��������� �������� �� �� ����� ����
�����������, ����������� ����� ������� ����������.
NEVER. ��� ����� ������� �� ���������.

����� ��� FAST REFRESH ��� ������������ �����.
������� � ������� DBMS_MVEW.PURGE_LOG, ����� ������� ����� �������� ��������� COMPLETE (METHOD => 'C')
*/

CREATE MATERIALIZED VIEW LOG ON ASSIGNMENTS WITH PRIMARY KEY INCLUDING NEW VALUES;

-- ����������� ��� ������� � ������� ����������
select * from USER_REFRESH_CHILDREN;

-- This procedure removes materialized views from a refresh group.
DBMS_REFRESH.SUBTRACT(name => 'WELL_REGIME', list => 'WELL_REGIME');
-- This procedure adds materialized views to a refresh group.
DBMS_REFRESH.ADD(name => 'RVP_GROUP', list => 'WELL_REGIME');
-- Manually refreshes a refresh group.
BEGIN
  DBMS_REFRESH.REFRESH('"RVP_GROUP"');
  COMMIT;
END;

-- ��� ������������ ���������
begin
  for cur in (SELECT 'DROP MATERIALIZED VIEW ' || T.MVIEW_NAME || ';' || CHR(13) || CHR(10) || 'CREATE MATERIALIZED VIEW ' ||
                     T.MVIEW_NAME || ' REFRESH FAST ON DEMAND AS SELECT * FROM ' || T.MVIEW_NAME || T.MASTER_LINK || ' "' ||
                     T.MVIEW_NAME || '";' || CHR(13) || CHR(10) || 'GRANT SELECT ON ' || T.MVIEW_NAME || ' TO WELLOP;' as TXT
                FROM USER_MVIEWS T) loop
    dbms_output.put_line(cur.txt);
  end loop;
end;

-- ���������� � ������
begin
  dbms_output.put_line('BEGIN');
  for cur in (SELECT 'BEGIN DBMS_REFRESH.SUBTRACT(NAME => ''' || T.MVIEW_NAME || ''', LIST => ''' || T.MVIEW_NAME ||
                     '''); EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(13) || CHR(10) ||
                     'DBMS_REFRESH.ADD(NAME => ''RVP_GROUP'', LIST => ''' || T.MVIEW_NAME || ''');' as TXT
                FROM USER_MVIEWS T) loop
    dbms_output.put_line(cur.txt);
  end loop;
  dbms_output.put_line('END;');
end;
