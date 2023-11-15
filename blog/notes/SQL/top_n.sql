--Как выбрать записи с n-ым количеством наивысших значений
--Например, должны быть получены имена и заработные платы сотрудников с 5 самыми высокими зарплатами.

-- 1 способ (DB2, Oracle и SQL Server)
select ename, sal
from (
    select a.ename, a.sal,
        dense_rank() over (order by a.sal desc) as rnk
    from emp a
) x
where rnk <= 5

-- 2 способ (MySQL и PostgreSQL)
select ename, sal
from (
    select a.ename, a.sal,
        (select count(distinct b.sal) from emp b where a.sal <= b.sal) as rnk
    from emp a
    -- или order by a.sal desc
) x
where rnk <= 5
order by rnk

-- 3 способ (Oracle)
select ename, sal
from (
    select a.ename, a.sal 
    from emp a
    order by a.sal desc
) x
where rownum <= 5

-- В 1 и 2 способах дубликаты не учитываются, т.е. результать может быть больше 5
