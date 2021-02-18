--поиск дубликатов
select name, count(name) as num from character_votes group by name having num>1 order by num desc;

--удаление дубликатов
DELETE t1 FROM character_votes t1, character_votes t2 WHERE t1.name=t2.name AND t1.id>t2.ID;

--поиск дубликатов 2 способ
select * from character_votes where name in (select name from character_votes group by name having count(*) > 1) order by name;

--поиск дубликатов 3 по нескольким пол¤м
select * from libr_records where (datevid,formno, invno) in (SELECT datevid,formno, invno
FROM libr_records
group by datevid,formno, invno
having count(*)>1)

-- в оракле парус 8
select
m.fact_doctype_rn, m.fact_docnumb, m.acnt_opersum, m.fact_docdate, count(*)
from V_ECONOPRS M  
where  M.OPERATION_CONTENTS='ѕрин¤тые об¤зательства'
and m.operation_date BETWEEN TO_DATE ('01.01.2012','DD/MM/YYYY') AND TO_DATE ('31.12.2012','DD/MM/YYYY')
group by m.fact_doctype_rn, m.fact_docnumb, m.acnt_opersum, m.fact_docdate
having count(*)>1

-- удаление дубликатов парус 8
delete from doclinks where rn in (
select max(d.rn)
  from doclinks d
        group by d.out_document
        having count(*)>1)

-- удаление дубликатов по rowid
delete from RAD_PARAM_TOTAL_TABLE t
 where t.rowid in (SELECT max(rowid)
                     FROM RAD_PARAM_TOTAL_TABLE
                    where param in ('sSRV_MODEL', 'sSRV_SN', 'ADDRESS')
                    group by link, param
                   having count(*) > 1);

--удаление дубликатов 2 способ -- ниже не провер¤л

-- ¬ариант с NOT IN. 
-- ќстаютс¤ строки с минимальным значением пол¤ DUPLICATE_ID среди дубликатов.
delete TEST_DUPLICATE
where duplicate_id not in (
        select min(duplicate_id)
        from TEST_DUPLICATE
        group by value
      );
-- “о же самое через NOT EXISTS.
delete TEST_DUPLICATE d
where not exists (
        select 1
        from (select min(duplicate_id) duplicate_id
              from TEST_DUPLICATE
              group by value
             ) d2
        where d.duplicate_id = d2.duplicate_id
      );
-- ¬ариант с использованием аналитической функции row_number()
delete TEST_DUPLICATE
where duplicate_id in (
        select duplicate_id
        from (select duplicate_id, row_number() over (partition by value order by null) rw
              from TEST_DUPLICATE
             )
        where rw > 1
      );
-- ¬ верхнем запросе нельз¤ сказать, кака¤ именно строка из дубликатов останетс¤, 
-- из-за услови¤ "ORDER BY NULL". ƒл¤ управлени¤ этим процессом 
-- можно отсортировать выборку в пределах каждого неуникального значени¤ 
-- так, чтобы строка, которую хотелось бы оставить, была первой. 
-- Ќапример, оставить строки с минимальным значением первичного ключа:
delete TEST_DUPLICATE
where duplicate_id in (
        select duplicate_id, row_number() over (partition by value order by duplicate_id) rw
              from TEST_DUPLICATE
             )
        where rw > 1
      );

--»сключение дубликатов (кроме DISTINCT и GROUP BY)
select job
  from (select job, row_number() over(partition by job order by job) rn
          from emp) x
 where rn = 1

