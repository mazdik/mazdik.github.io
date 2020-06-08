select  l.sid,s.serial#,s.username,s.terminal, 
        decode(l.type,'RW','RW - Row Wait Enqueue', 
                    'TM','TM - DML Enqueue', 
                    'TX','TX - Trans Enqueue', 
                    'UL','UL - User',l.type||'System') res, 
        substr(t.name,1,15) tab,u.name owner, 
        l.id1,l.id2, 
        decode(l.lmode,1,'No Lock', 
                2,'Row Share', 
                3,'Row Exclusive', 
                4,'Share', 
                5,'Shr Row Excl', 
                6,'Exclusive',null) lmode, 
        decode(l.request,1,'No Lock', 
                2,'Row Share', 
                3,'Row Excl', 
                4,'Share', 
                5,'Shr Row Excl', 
                6,'Exclusive',null) request 
from v$lock l, v$session s, 
sys.user$ u,sys.obj$ t 
where l.sid = s.sid 
and s.type != 'BACKGROUND' 
and t.name = 'CHEQUE_DISCOUNT_F'
and t.obj# = l.id1 
and u.user# = t.owner# 

---- кто кого блокирует
select (select username || ' - ' || osuser from v$session where sid = a.sid) blocker,
       a.sid || ', ' || (select serial# from v$session where sid = a.sid) sid_serial,
       ' is blocking ',
       (select username || ' - ' || osuser from v$session where sid = b.sid) blockee,
       b.sid || ', ' || (select serial# from v$session where sid = b.sid) sid_serial
  from v$lock a, v$lock b
 where a.block = 1
   and b.request > 0
   and a.id1 = b.id1
   and a.id2 = b.id2;
