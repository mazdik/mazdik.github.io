------- обычный запрос -------
select
  OBJECT_TYPE, count(*) cnt,
  ROW_NUMBER() OVER (ORDER BY OBJECT_TYPE) seq
from SYS.ALL_OBJECTS
where OWNER='LIDER'
and OBJECT_TYPE in ('FUNCTION', 'INDEX', 'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'TABLE', 'TRIGGER', 'VIEW')
group by OBJECT_TYPE

-- Вариант с pivot (Oracle 11) --
select *
from
  (select object_type
   from SYS.ALL_OBJECTS where OWNER='LIDER')
   pivot
    (count(object_type)
      for object_type in ('SEQUENCE', 'PROCEDURE', 'VIEW', 'SYNONYM'));

------- Вариант с ROW_NUMBER() OVER -------
SELECT
MAX(DECODE(seq,1,cnt,NULL)) "FUNCTION",
MAX(DECODE(seq,2,cnt,NULL)) "INDEX",
MAX(DECODE(seq,3,cnt,NULL)) "PACKAGE",
MAX(DECODE(seq,4,cnt,NULL)) "PACKAGE BODY",
MAX(DECODE(seq,5,cnt,NULL)) "PROCEDURE",
MAX(DECODE(seq,6,cnt,NULL)) "TABLE",
MAX(DECODE(seq,7,cnt,NULL)) "TRIGGER",
MAX(DECODE(seq,8,cnt,NULL)) "VIEW"
FROM
(
select
  OBJECT_TYPE, count(*) cnt,
  ROW_NUMBER() OVER (ORDER BY OBJECT_TYPE) seq
from SYS.ALL_OBJECTS
where OWNER='LIDER'
and OBJECT_TYPE in ('FUNCTION', 'INDEX', 'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'TABLE', 'TRIGGER', 'VIEW')
group by OBJECT_TYPE
)

------- Вариант с LEAD -------
select * from (
select
LEAD(t.cnt, 0, 0) OVER (ORDER BY OBJECT_TYPE) AS "FUNCTION",
LEAD(t.cnt, 1, 0) OVER (ORDER BY OBJECT_TYPE) AS "INDEX",
LEAD(t.cnt, 2, 0) OVER (ORDER BY OBJECT_TYPE) AS "PACKAGE",
LEAD(t.cnt, 3, 0) OVER (ORDER BY OBJECT_TYPE) AS "PACKAGE BODY",
LEAD(t.cnt, 4, 0) OVER (ORDER BY OBJECT_TYPE) AS "PROCEDURE",
LEAD(t.cnt, 5, 0) OVER (ORDER BY OBJECT_TYPE) AS "TABLE",
LEAD(t.cnt, 6, 0) OVER (ORDER BY OBJECT_TYPE) AS "TRIGGER",
LEAD(t.cnt, 7, 0) OVER (ORDER BY OBJECT_TYPE) AS "VIEW"
from (
select OBJECT_TYPE, count(*) cnt
from SYS.ALL_OBJECTS
where OWNER='LIDER'
and OBJECT_TYPE in ('FUNCTION', 'INDEX', 'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'TABLE', 'TRIGGER', 'VIEW')
group by OBJECT_TYPE
order by OBJECT_TYPE
) t
) where rownum=1

------- Вариант с LAG -------
select * from (
select
ROW_NUMBER() OVER (ORDER BY null) rnum,
LAG(t.cnt, 7, 0) OVER (ORDER BY OBJECT_TYPE) AS "FUNCTION",
LAG(t.cnt, 6, 0) OVER (ORDER BY OBJECT_TYPE) AS "INDEX",
LAG(t.cnt, 5, 0) OVER (ORDER BY OBJECT_TYPE) AS "PACKAGE",
LAG(t.cnt, 4, 0) OVER (ORDER BY OBJECT_TYPE) AS "PACKAGE BODY",
LAG(t.cnt, 3, 0) OVER (ORDER BY OBJECT_TYPE) AS "PROCEDURE",
LAG(t.cnt, 2, 0) OVER (ORDER BY OBJECT_TYPE) AS "TABLE",
LAG(t.cnt, 1, 0) OVER (ORDER BY OBJECT_TYPE) AS "TRIGGER",
LAG(t.cnt, 0, 0) OVER (ORDER BY OBJECT_TYPE) AS "VIEW"
from (
select OBJECT_TYPE, count(*) cnt
from SYS.ALL_OBJECTS
where OWNER='LIDER'
and OBJECT_TYPE in ('FUNCTION', 'INDEX', 'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'TABLE', 'TRIGGER', 'VIEW')
group by OBJECT_TYPE
order by OBJECT_TYPE
) t
) where rnum=8

------- Вариант с CASE -------
select sum(
         case when OBJECT_TYPE = 'FUNCTION'
              then cnt
              else 0 end ) as "FUNCTION",
       sum(
         case when OBJECT_TYPE = 'INDEX'
              then cnt
              else 0 end ) as "INDEX",
       sum(
         case when OBJECT_TYPE = 'PACKAGE'
              then cnt
              else 0 end ) as "PACKAGE",
       sum(
         case when OBJECT_TYPE = 'PACKAGE BODY'
              then cnt
              else 0 end ) as "PACKAGE BODY",
       sum(
         case when OBJECT_TYPE = 'PROCEDURE'
              then cnt
              else 0 end ) as "PROCEDURE",
       sum(
         case when OBJECT_TYPE = 'TABLE'
              then cnt
              else 0 end ) as "TABLE",
       sum(
         case when OBJECT_TYPE = 'TRIGGER'
              then cnt
              else 0 end ) as "TRIGGER",
       sum(
         case when OBJECT_TYPE = 'VIEW'
              then cnt
              else 0 end ) as "VIEW"          
from
(
select
  OBJECT_TYPE, count(*) cnt,
  ROW_NUMBER() OVER (ORDER BY OBJECT_TYPE) seq
from SYS.ALL_OBJECTS
where OWNER='LIDER'
and OBJECT_TYPE in ('FUNCTION', 'INDEX', 'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'TABLE', 'TRIGGER', 'VIEW')
group by OBJECT_TYPE
)

-- sql с транспонированием
select 
MAX(DECODE(seq,1,contr_name,NULL)) highest,
MAX(DECODE(seq,1,auto_full,NULL)) auto_full,
MAX(DECODE(seq,2,contr_name,NULL)) second,
MAX(DECODE(seq,1,auto_full,NULL)) auto_full,
MAX(DECODE(seq,3,contr_name,NULL)) third,
MAX(DECODE(seq,3,auto_full,NULL)) auto_full
from (
select home, contr_name, auto_full,
ROW_NUMBER() OVER (PARTITION BY home ORDER BY auto_full DESC NULLS LAST) seq
   from R6505_level_gauge
)
where seq <=3
group by home

-- PIVOT
select *
  from (select m.well_id, m.measure_date, m.measure_type_id, m.value
          from well_measure m
         where m.measure_date > to_date('01.03.2016', 'DD.MM.YYYY')
           and m.measure_date <= to_date('20.04.2016', 'DD.MM.YYYY')
           and m.well_id = 9030000112)
pivot(max(value)
   for measure_type_id in(1, 3, 4, 78, 79, 80, 81, 82, 84, 85, 88))
order by measure_date desc

/* PIVOT ALIAS */
pivot(max(V1.VALUE_MONTH) as VALUE_MONTH, max(V1.VALUE_YEAR) as VALUE_YEAR, max(V1.VALUE_FULL) as VALUE_FULL
	for CODE in('DN_WEIGHT', 'DW_WEIGHT', 'DW_VOLUME'))
/* PIVOT ALIAS */
pivot(max(value)
   for measure_type_id in(1 as NAME1, 3 as NAME2, 4 as NAME3))
