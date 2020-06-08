ALTER SYSTEM KILL SESSION 'sid,serial#';
ALTER SYSTEM KILL SESSION '1347,34538';

ALTER SYSTEM DISCONNECT SESSION 'sid,serial#' IMMEDIATE;
ALTER SYSTEM DISCONNECT SESSION '1347,34538' IMMEDIATE;

--
select s.OSUSER, count(*)
  from v$process p, v$session s
 where paddr = addr
 group by s.OSUSER
 order by count(*) desc

-- Количество процессов - processes
select * from V$RESOURCE_LIMIT
