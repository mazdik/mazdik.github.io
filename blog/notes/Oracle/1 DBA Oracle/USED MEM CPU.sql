--Сколько памяти в текущий момент используется
SELECT NVL (username, 'SYS-BKGD') username, sess.sid, round(SUM (VALUE) /1024/1024, 2) sess_mem
    FROM v$session sess, v$sesstat stat, v$statname name
   WHERE sess.sid = stat.sid
     AND stat.statistic# = name.statistic#
     AND name.name LIKE 'session % memory'
GROUP BY username, sess.sid;

--Поиск пользователей, которые больше всех используют ресурсы ЦП
select ss.username, se.sid, value/100 cpu_usage_seconds
  from v$session ss, v$sesstat se, v$statname sn
 where se.statistic# = sn.statistic#
   and se.sid = ss.sid
   and name like '%CPU used by this session%'
   and ss.status = 'ACTIVE'
   and ss.username is not null
 order by value desc;

--------------
select decode(grouping(nm), 1, 'total', nm) nm,
       round(sum(val / 1024 / 1024)) mb
  from (select 'sga' nm, sum(value) val
          from v$sga
        union all
        select 'pga', sum(a.value)
          from v$sesstat a, v$statname b
         where b.name = 'session pga memory'
           and a.statistic# = b.statistic#)
 group by rollup(nm);

--------------
select t.NAME, round(t.VALUE/1024/1024) mb from sys.v_$sga t;

--использованию памяти PGA процессами Oracle
SELECT pid, category, allocated, used from v$process_memory;

--Сколько памяти PGA (в байтах) в текущий момент используется различными пользователями.
SELECT
s.value,s.sid,a.username
FROM
V$SESSTAT S, V$STATNAME N, V$SESSION A
WHERE
n.STATISTIC# = s.STATISTIC# and
name = 'session pga memory'
AND s.sid=a.sid
ORDER BY s.value;

--выбирать для PGA оптимальный уровень объема памяти
SELECT ROUND(pga_target_for_estimate/1024/1024) target_mb,
estd_pga_cache_hit_percentage cache_hit_perc,
estd_overalloc_count
FROM V$PGA_TARGET_ADVICE;
