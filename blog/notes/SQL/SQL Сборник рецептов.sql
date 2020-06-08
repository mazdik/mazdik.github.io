/*
Извлечение из одной таблицы значений, которых нет в другой таблице
*/

-- 1 способ Oracle (minus)
select t.link from P_R_SERVER_NAME t
minus
select t2.link from P_R_SERVER_NAME_2 t2

-- 2 способ (not in)
select t.link from P_R_SERVER_NAME t
where t.link not in
(select t2.link from P_R_SERVER_NAME_2 t2)

-- Если в t2.link будет хоть один NULL то результат будет пустой
--поэтому лучше использовать not exists

-- 3 способ (not exists)
select t.link from P_R_SERVER_NAME t
where not exists
(select null from P_R_SERVER_NAME_2 t2 where t2.link=t.link)

-- сравнение по всем полям таблицы
select * from t2 minus select * from t1

-- сравнение по всем полям таблицы, точное совпадение подмножеств t1 и t2 т.е. данные которые есть в таблице t1 и в таблице t2
select * from t2 intersect select * from t1

/*
Извлечение из таблицы строк, для которых нет соответствия в другой таблице
*/

-- 1 способ (+)
select t.* from P_R_SERVER_NAME t, P_R_SERVER_NAME_2 t2
where t.link=t2.link(+)
and t2.link is null

-- 2 способ (join)
select t.*
from P_R_SERVER_NAME t left outer join P_R_SERVER_NAME_2 t2 
on (t.link = t2.link) 
where t2.link is null


/* Вычисление моды - это наиболее часто встречающийся элемент столбца значений
Например:
800
1100
2975
3000
3000
мода равна 3000.
*/

-- 1 способ
select zond
 from (
 select zond,
 dense_rank()over(order by cnt desc) as rnk
 from (
 select zond, count(*) as cnt
 from ZOND_6505
 group by zond
 ) x
 ) y
 where rnk = 1
 -- 2 способ - вернет только одно значение даже если их несколько
 select max(zond)
 keep(dense_rank first order by cnt desc) zond
 from (
 select zond, count(*) cnt
 from ZOND_6505
 group by zond
 )
 
 -- 3 способ
 select zond 
 from ZOND_6505 
 group by zond 
 having count(*) >= all ( select count(*) 
 from ZOND_6505 
 group by zond )

/*
Последовательность чисел
*/

-- 1 способ
with x as
 (select level id from dual connect by level <= 10)
select * from x

-- 2 способ
select array id
  from dual model dimension by(0 idx) measures(1 array) rules iterate(10)(array [ iteration_number ] = iteration_number + 1)


  
--Вывести список сотрудников, получающих максимальную заработную плату в своем отделе

-- 1 способ
select a.*
  from EMP a
 where a.sal = (select max(sal) from EMP b where b.deptno = a.deptno)
 
-- 2 способ
select e.* from EMP e  
join (select deptno, max(sal) as max_salary 
            from EMP e2 
         group by deptno) d
  on d.deptno=e.deptno
where e.sal = d.max_salary

-- 3 способ
select *
  from (select t.*, max(sal) over(partition by t.deptno) as max_salary
          from EMP t) tt
 where tt.sal = tt.max_salary

-- 4 способ
select t.*
  from EMP t
 where sal not in (select a.sal
                     from EMP a, EMP b
                    where a.sal < b.sal
                      and b.deptno = t.deptno)

-- 5 способ
select t.*
  from EMP t
 where t.sal >= all (select sal from EMP where deptno = t.deptno)


--Найти список ID отделов с максимальной суммарной зарплатой сотрудников
-- 1 способ
with sum_salary as
  ( select EMPNO, sum(sal) salary
    from   EMP
    group  by EMPNO )
select EMPNO 
from   sum_salary a       
where  a.salary = ( select max(salary) from sum_salary ) 
-- 2 способ
select * 
from (
  select e.EMPNO,dense_rank()over(order by sum(sal) desc) dr
  from EMP e
  group by e.EMPNO
)
where dr=1

--Вычисление процентов
-- 1 способ
select (sum(
case when deptno = 10 then sal end)/sum(sal)
)*100 as pct
from emp
-- 2 способ
select distinct cast(d10 as decimal)/total*100 as pct
from (
select deptno,
sum(sal)over() total,
sum(sal)over(partition by deptno) d10
from emp
) x
where deptno=10
-- 3 способ
RATIO_TO_REPORT

--division by zero (cast для PostgreSQL важен)
SELECT CASE WHEN (total)>0 THEN round((CAST(COALESCE(d10,0) AS DECIMAL)/total)*100, 0) ELSE 0 END AS percent
