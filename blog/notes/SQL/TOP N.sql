--Как выбрать записи с n-ым количеством наивысших значений
--Например, должны быть получены имена и заработные платы сотрудников с 5 самыми высокими зарплатами.

-- 1 способ (DB2, Oracle и SQL Server)
select ename,sal
from (
select ename, sal,
dense_rank() over (order by sal desc) dr
from emp
) x
where dr <= 5

-- 2 способ (MySQL и PostgreSQL)
select ename,sal
from (
select (select count(distinct b.sal)
from emp b
where a.sal <= b.sal) as rnk,
a.sal,
a.ename
from emp a
-- или order by a.sal desc
)
where rnk <= 5
order by rnk

-- 3 способ
select ename,sal
from (
select * from emp order by sal desc
)
where rownum <= 5

-- В 1 и 2 способах дубликаты не учитываются, т.е. результать может быть больше 5
