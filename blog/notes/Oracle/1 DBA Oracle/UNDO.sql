-- гарантированное сохранение информации отмены
ALTER TABLESPACE undots1 RETENTION GUARANTEE;
ALTER TABLESPACE undots1 RETENTION NOGUARANTEE;

--ALTER TABLESPACE undotbs1 RETENTION GUARANTEE;
SELECT tablespace_name, retention FROM dba_tablespaces;

--Определяет длину самого длинного запроса (в секундах)
select max(maxquerylen), max(tuned_undoretention) from v$undostat;

-- 3 часа
ALTER SYSTEM SET UNDO_RETENTION = 10800 SCOPE=BOTH;

--
DBA_ROLLBACK_SEGS -- информация о всех сегментах отката
V$ROLLSTAT -- размер, текущее число экстентов, наивысшая точка, оптимальный размер
V$ROLLNAME -- имя сегмента отката и его номер, соответствующий записям в v$rollstat
V$TRANSACTION -- адрес сеанса и использование сегментов отката текущими транзакциями
V$SESSION -- имя sid и порядковый номер адреса сеанса, соответствуют адресу сеанса в v$transaction
V$UNDOSTAT

-- size used by each session
select s.sid, 
       s.username,
       round(sum(ss.value) / 1024 / 1024, 2) as undo_size_mb
from  v$sesstat ss
  join v$session s on s.sid = ss.sid
  join v$statname stat on stat.statistic# = ss.statistic#
where stat.name = 'undo change vector size'
and s.type <> 'BACKGROUND'
and s.username IS NOT NULL
group by s.sid, s.username;

--Не закоммиченная транзакция, такого пользователя нужно убить, оракл откатит убитую транзакцию
select a.username,
a.sid,
a.serial#,
to_char(b.start_time,'MM/DD/YY HH24:MI:SS') as start_time,
c.name
from v$session a,
v$transaction b,
v$rollname c,
v$rollstat d
where a.saddr=b.ses_addr
and b.xidusn=c.usn
and c.usn=d.usn
and ((d.curext=b.start_uext-1) or
((d.curext=d.extents-1) and b.start_uext=0))

--To monitor rollback usage (waits/gets should be < 1 %)
select name, waits, gets
from v$rollstat, v$rollname
where v$rollstat.usn = v$rollname.usn;

--
select
substr(s.username,1,18) username,
substr(s.program,1,15) program,
decode(s.command,
0,'No Command',
1,'Create Table',
2,'Insert',
3,'Select',
6,'Update',
7,'Delete',
9,'Create Index',
15,'Alter Table',
21,'Create View',
23,'Validate Index',
35,'Alter Database',
39,'Create Tablespace',
41,'Drop Tablespace',
40,'Alter Tablespace',
53,'Drop User',
62,'Analyze Table',
63,'Analyze Index',
s.command||': Other') command
from
v$session s,
v$process p,
v$transaction t,
v$rollstat r,
v$rollname n
where s.paddr = p.addr
and s.taddr = t.addr (+)
and t.xidusn = r.usn (+)
and r.usn = n.usn (+)
order by 1

/*
Ошибки

ORA-01562 insufficient space in rollback segment
недостаточно места в сегменте отката

ORA-01555 snapshot to old (rollback segment to small)
моментальный снимок слишком стар
сегмент отката слишком мал
*/

--Displaying Whether a Rollback Segment Has Gone Offline
SELECT name, xacts "ACTIVE TRANSACTIONS"
FROM v$rollname, v$rollstat
WHERE status = 'PENDING OFFLINE'
AND v$rollname.usn = v$rollstat.usn;

--РБ сегменты
select segment_name, status, tablespace_name
  from dba_rollback_segs
 where status = 'NEEDS RECOVERY';
