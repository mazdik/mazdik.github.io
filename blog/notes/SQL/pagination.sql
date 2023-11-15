------------------------------
-- 1 способ ROWNUM
------------------------------
select * 
  from (
    select /*+ FIRST_ROWS(n) */ 
        a.*, rownum rnum 
      from (your_query_goes_here with order by) a 
      where rownum <= :MAX_ROW_TO_FETCH
  )
where rnum  >= :MIN_ROW_TO_FETCH;

------------------------------

select *
  from (
    select a.*, rownum rnum
      from
    (select t.db_link from dba_db_links t) a
     where rownum <= 150
  )
where rnum >= 148;
	
------------------------------
-- 2 способ row_number()
------------------------------
select db_link 
from (
  select row_number() over (order by db_link) as rn, 
  db_link 
  from dba_db_links
) x
where rn between 1 and 5


/* Пагинация быстрее */
-- 0,172 sec
select V2.*
  from (select V1.*, row_number() over(order by 1) as RN
          from (select T.*, count(*) over() as ROW_CNT from (select * from V_WELL_FULL T) T where 1=1) V1) V2
 where V2.RN between 1 and 25
-- 0,893 sec
select V1.*
      from (select T.*, row_number() over(order by 1) as RN, count(*) over() as ROW_CNT
              from (select * from V_WELL_FULL T) T where 1=1) V1
     where V1.RN between 1 and 25
