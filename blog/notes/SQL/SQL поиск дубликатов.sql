--����� ����������
select name, count(name) as num from character_votes group by name having num>1 order by num desc;

--�������� ����������
DELETE t1 FROM character_votes t1, character_votes t2 WHERE t1.name=t2.name AND t1.id>t2.ID;

--����� ���������� 2 ������
select * from character_votes where name in (select name from character_votes group by name having count(*) > 1) order by name;

--����� ���������� 3 �� ���������� �����
select * from libr_records where (datevid,formno, invno) in (SELECT datevid,formno, invno
FROM libr_records
group by datevid,formno, invno
having count(*)>1)

-- � ������ ����� 8
select
m.fact_doctype_rn, m.fact_docnumb, m.acnt_opersum, m.fact_docdate, count(*)
from V_ECONOPRS M  
where  M.OPERATION_CONTENTS='�������� �������������'
and m.operation_date BETWEEN TO_DATE ('01.01.2012','DD/MM/YYYY') AND TO_DATE ('31.12.2012','DD/MM/YYYY')
group by m.fact_doctype_rn, m.fact_docnumb, m.acnt_opersum, m.fact_docdate
having count(*)>1

-- �������� ���������� ����� 8
delete from doclinks where rn in (
select max(d.rn)
  from doclinks d
        group by d.out_document
        having count(*)>1)

-- �������� ���������� �� rowid
delete from RAD_PARAM_TOTAL_TABLE t
 where t.rowid in (SELECT max(rowid)
                     FROM RAD_PARAM_TOTAL_TABLE
                    where param in ('sSRV_MODEL', 'sSRV_SN', 'ADDRESS')
                    group by link, param
                   having count(*) > 1);

--�������� ���������� 2 ������ -- ���� �� ��������

-- ������� � NOT IN. 
-- �������� ������ � ����������� ��������� ���� DUPLICATE_ID ����� ����������.
delete TEST_DUPLICATE
where duplicate_id not in (
        select min(duplicate_id)
        from TEST_DUPLICATE
        group by value
      );
-- �� �� ����� ����� NOT EXISTS.
delete TEST_DUPLICATE d
where not exists (
        select 1
        from (select min(duplicate_id) duplicate_id
              from TEST_DUPLICATE
              group by value
             ) d2
        where d.duplicate_id = d2.duplicate_id
      );
-- ������� � �������������� ������������� ������� row_number()
delete TEST_DUPLICATE
where duplicate_id in (
        select duplicate_id
        from (select duplicate_id, row_number() over (partition by value order by null) rw
              from TEST_DUPLICATE
             )
        where rw > 1
      );
-- � ������� ������� ������ �������, ����� ������ ������ �� ���������� ���������, 
-- ��-�� ������� "ORDER BY NULL". ��� ���������� ���� ��������� 
-- ����� ������������� ������� � �������� ������� ������������� �������� 
-- ���, ����� ������, ������� �������� �� ��������, ���� ������. 
-- ��������, �������� ������ � ����������� ��������� ���������� �����:
delete TEST_DUPLICATE
where duplicate_id in (
        select duplicate_id, row_number() over (partition by value order by duplicate_id) rw
              from TEST_DUPLICATE
             )
        where rw > 1
      );

--���������� ���������� (����� DISTINCT � GROUP BY)
select job
  from (select job, row_number() over(partition by job order by job) rn
          from emp) x
 where rn = 1

