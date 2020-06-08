ALTER SYSTEM SET open_cursors = 600 SCOPE=BOTH;


select count(*) from v$open_cursor;

---------------Количество открытых курсоров по пользователям ---------------------
 
select sum(a.value) total_cur,
       round(avg(a.value), 2) avg_cur,
       max(a.value) max_cur,
       s.username,
       s.machine
  from v$sesstat a, v$statname b, v$session s
 where a.statistic# = b.statistic#
   and s.sid = a.sid
   and b.name = 'opened cursors current'
 group by s.username, s.machine
 order by 1 desc;

--------------------------------------------

SELECT s.osuser, s.username, s.sid, count(*) cnt     
 FROM v$session s, v$open_cursor oc      
 WHERE s.saddr = oc.saddr AND            
 s.username IS NOT NULL      
 GROUP BY s.osuser, s.username, s.sid
 order by 4 desc;

--------------- Количество открытых курсоров -------------------------
 
select sum(a.value), b.name       
 from v$sesstat a, v$statname b      
 where a.statistic# = b.statistic#      
 and b.name = 'opened cursors current'      
 group by b.name 

 