/* Принятых в один день, сравниваются со следующей по хронологии датой */
select ename, hiredate, next_hd, next_hd - hiredate diff
  from (select deptno, ename, hiredate, lead(hiredate, cnt - rn + 1) over(order by hiredate) next_hd
          from (select deptno,
                       ename,
                       hiredate,
                       count(*) over(partition by hiredate) cnt,
                       row_number() over(partition by hiredate order by empno) rn
                  from emp
                 where deptno = 10))

/* Most efficient way to check if a record exists */			 
select case 
            when exists (select 1 
                         from sales 
                         where sales_type = 'Accessories') 
            then 'Y' 
            else 'N' 
        end as rec_exists
from dual;

/* FIRST / LAST
08.07.2014	AO0031
10.07.2014	AO0031
09.08.2015	AO0027
*/
select
max(T.AO_1) keep(dense_rank first order by T.BEGIN_DATE) "FIRST", --AO0031
max(T.AO_1) keep(dense_rank last order by T.BEGIN_DATE) "LAST" --AO0027
  from WELL_LAYER_ALLOCATION T
 where T.WELL_ID = 2380037500
 and T.LAYER_ID='PL1044'
 group by T.LAYER_ID

/* Нарастающий итог */
sum(T.VALUE_MONTH) over(partition by T.PARAM_ID, trunc(T.DDATE, 'YEAR'), T.WELL_ID, T.LAYER_ID, T.PURPOSE_ID, T.EXPL_METHOD_ID, T.AGENT_ID order by T.DDATE) VALUE_YEAR,
sum(T.VALUE_MONTH) over(partition by T.PARAM_ID, T.WELL_ID, T.LAYER_ID, T.PURPOSE_ID, T.EXPL_METHOD_ID, T.AGENT_ID order by T.DDATE) VALUE_FULL

/* Обрезать до запятой */
select substr('ASS,AA', 0, instr('ASS,AA', ',', -1) - 1) from dual

/* Передать строку в функцию */
SELECT function(table1_typ(column1, column2, column3))
  FROM table1 t1

/* Аналог LAG и LEAD */
MAX(CALENDAR_DATE) OVER(PARTITION BY 1 ORDER BY CALENDAR_DATE ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS LAG_
MIN(CALENDAR_DATE) OVER(PARTITION BY 1 ORDER BY CALENDAR_DATE ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING) AS LEAD_

/* Нарастающая длина строки в сумме (+2 для символов ', ') */
sum(length(T.ENTERPRISE_ID) + 2) over (order by T.ENTERPRISE_ID rows between unbounded preceding and current row) NLENGTH

/* Delete not exist */
-- 1 Способ
delete from t1 where not exists (select 1 from t2 where t1.key = t2.key);
-- 2 Способ
delete a from request_fo a 
left join rm_trans b on b.values_key = a.req_year
where b.values_key is null;
-- Insert not exist
insert into WELL_REFRESH_QUEUE
(WELL_ID)
select nWELL_ID from dual 
where not exists (select 1 from WELL_REFRESH_QUEUE where WELL_ID = nWELL_ID);

/* Объединение промежутков */
lead(T.STATE_ID, 1) over(partition by T.WELL_ID order by T.BEGIN_DATE) as STATE_LEAD,
lag(T.STATE_ID, 1) over(partition by T.WELL_ID order by T.BEGIN_DATE) as STATE_LAG

where (STATE_ID = STATE_LEAD and (STATE_ID <> STATE_LAG or STATE_LAG is null))
	or ((STATE_ID <> STATE_LEAD or STATE_LEAD is null) and (STATE_ID <> STATE_LAG or STATE_LAG is null))

/* Объединение промежутков по нескольким полям */
(T.STATE_ID || T.WORKING_CYCLE || T.ACCUM_CYCLE) as ROW_ID,
lead(T.STATE_ID || T.WORKING_CYCLE || T.ACCUM_CYCLE, 1) over(partition by T.WELL_ID order by T.BEGIN_DATE) as ROW_LEAD,
lag(T.STATE_ID || T.WORKING_CYCLE || T.ACCUM_CYCLE, 1) over(partition by T.WELL_ID order by T.BEGIN_DATE) as ROW_LAG

where (ROW_ID = ROW_LEAD and (ROW_ID <> ROW_LAG or ROW_LAG is null))
	or ((ROW_ID <> ROW_LEAD or ROW_LEAD is null) and (ROW_ID <> ROW_LAG or ROW_LAG is null))

/* Отличия '= ANY()' и 'IN ()'
IN- Equal to any member in the list
ANY- Compare value to **each** value returned by the subquery
ALL- Compare value to **EVERY** value returned by the subquery

<ANY() - less than maximum
>ANY() - more than minimum
=ANY() - equivalent to IN
>ALL() - more than the maximum
<ALL() - less than the minimum
*/
-- IN
SELECT last_name, salary,department_id
FROM employees
WHERE salary IN (SELECT MIN(salary)
                 FROM employees
                 GROUP BY department_id);
-- <ANY
SELECT employee_id, last_name, salary, job_id
FROM employees
WHERE salary <ANY
                (SELECT salary
                 FROM employees
                 WHERE job_id = 'IT_PROG')
AND job_id <> 'IT_PROG';
-- <ALL
SELECT employee_id,last_name, salary,job_id
FROM employees
WHERE salary <ALL
                (SELECT salary
                 FROM employees
                 WHERE job_id = 'IT_PROG')
AND job_id <> 'IT_PROG';
-- ANY (or its synonym SOME) is a syntax sugar for EXISTS with a simple correlation:
SELECT * FROM mytable WHERE x <= ANY (SELECT y FROM othertable)
SELECT * FROM mytable m WHERE EXISTS (SELECT NULL FROM othertable o WHERE m.x <= o.y)

--JSON from SQL
'[' || LISTAGG('{"LAYER_ID": "' || LAYER_ID || '", "DISTRIBUTION_OIL": ' || DISTRIBUTION_OIL || '}', ', ') within group(order by BEGIN_DATE) || ']'

--Количество вхождений символа в строку
select length('/ENTERPRISE/FIELD') - length(replace('/ENTERPRISE/FIELD' , '/')) from dual

-- Dynamic Order by clause
order by (case when in_sort_column = 'col1' then col1 end),
         (case when in_sort_column = 'col2' then col2 end),
         (case when in_sort_column = 'col3' then col3 end)
--
order by decode( :x, 'LN_AD', last_name ), 
		 decode( :x, 'LN_AD', reserve_begin_date ),
         decode( :x, 'OR_ID', order_id );
--
order by case when &x= 'LEVEL_ID' and &xx = 1 then LEVEL_ID end ASC,
         case when &x= 'LEVEL_ID' and &xx = -1 then LEVEL_ID end DESC

/* Найти минимальный свободный номер (Поиск "дырки") */
       ID
---------
        1
        2
        3
        5
        7
        8
        9
       10
select min(id) + 1
from (select id, lead(id) over (order by id) -id a from melamory)
where a <>1;
-- Результат: 4

--Вариант 2 (Свободные интервалы от и до, количество)
select T.ID + 1 as "BEGIN", min(T1.ID) - 1 as "END", min(T1.ID) - T.ID - 1 as "COUNT"
  from TABLE1 T
  join TABLE1 T1
    on T.ID < T1.ID
--where T.ID <= 1000 and T1.ID <= 1000
 group by T.ID
having min (T1.ID) - T.ID > 1

-- Одну строку в подзапросе
select min(t.well_id) KEEP (dense_rank first ORDER BY t.begin_date) from well t

--Оптимизация (dEND_DATE вместо null)
LEAD(T.MEASURE_DATE, 1, dEND_DATE) OVER(PARTITION BY T.WELL_ID, T.MEASURE_TYPE_ID ORDER BY T.MEASURE_DATE) AS END_DATE
WHERE V3.BEGIN_DATE < dEND_DATE
AND V3.END_DATE > dBEGIN_DATE

-- UPDATE order by
update WEB_REPORTS_MENU R
   set R.SORT_ORDER =
       (select V2.RN
          from (select T.ID, row_number() over(order by T.NAME) as RN from WEB_REPORTS_MENU T where T.PARENT_ID = 1500030) V2
         where V2.ID = R.ID)
 where R.ID in (select T.ID from WEB_REPORTS_MENU T where T.PARENT_ID = 1500030)
