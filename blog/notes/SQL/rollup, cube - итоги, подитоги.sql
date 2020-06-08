/*
Группировка и итоги
*/

-- 1 способ (union all)
select object_type, count(*)
  from user_objects
 group by object_type
union all
select 'TOTAL', count(*)
from user_objects
 
-- 2 способ (rollup)
select decode(grouping(object_type), 0, object_type, 'TOTAL') as object_type, count(*)
  from user_objects t
 group by rollup(object_type)


-- Итоги, подитоги rollup
select object_type, owner,
        case grouping(object_type)||grouping(owner)
         when '00' then 'TOTAL BY OBJECT_TYPE AND OWNER'
         when '10' then 'TOTAL BY OBJECT_TYPE'
         when '01' then 'TOTAL BY OWNER'
         when '11' then 'GRAND TOTAL'
        end TOTAL,
       count(*)
  from ALL_OBJECTS t
 group by rollup(object_type, owner)
 
-- результат
EVALUATION CONTEXT	SYS		TOTAL BY OBJECT_TYPE AND OWNER	7
EVALUATION CONTEXT	SYSMAN	TOTAL BY OBJECT_TYPE AND OWNER	1
EVALUATION CONTEXT			TOTAL BY OWNER					8
							GRAND TOTAL						76668

-- Итоги, подитоги cube
select object_type, owner,
        case grouping(object_type)||grouping(owner)
         when '00' then 'TOTAL BY OBJECT_TYPE AND OWNER'
         when '10' then 'TOTAL BY OBJECT_TYPE'
         when '01' then 'TOTAL BY OWNER'
         when '11' then 'GRAND TOTAL'
        end TOTAL,
       count(*)
  from ALL_OBJECTS t
 group by cube(object_type, owner)
 order by grouping(owner), grouping(object_type)
-- или можно так: group by grouping sets ((owner),(object_type),(object_type, owner),())
 
 -- результат
JOB	SYS				TOTAL BY OBJECT_TYPE AND OWNER	4
JOB	ORACLE_OCM		TOTAL BY OBJECT_TYPE AND OWNER	2
JOB	EXFSYS			TOTAL BY OBJECT_TYPE AND OWNER	2
		EXFSYS		TOTAL BY OBJECT_TYPE			2
		SYS			TOTAL BY OBJECT_TYPE			4
		ORACLE_OCM	TOTAL BY OBJECT_TYPE			2
	JOB				TOTAL BY OWNER					8
					GRAND TOTAL						8
			
--Категория с условием
select *
  from (select ORG,
               FIELD,
               --WELL_CATEGORY,
               case
                 when (grouping(ORG) || grouping(FIELD) || grouping(WELL_CATEGORY) = '010' and
                      WELL_CATEGORY = 'Эксплуат.') then
                  'TOTAL'
                 else
                  WELL_CATEGORY
               end WELL_CATEGORY,
               sum(F_GIVING_OIL) F_GIVING_OIL
          from table(PKG_REPORT_FUND.PIPELINED_REPORT(sysdate, null)) V1
         group by cube(ORG, FIELD, WELL_CATEGORY)) V2
/* убираем не нужные под итоги */
 where (V2.ORG is not null and V2.FIELD is not null and V2.WELL_CATEGORY is not null)
    or (V2.WELL_CATEGORY = 'TOTAL')

