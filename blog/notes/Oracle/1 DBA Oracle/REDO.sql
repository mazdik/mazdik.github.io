--какие сеансы генерируют больше всего redo
select s.SID,
       s.USERNAME,
       s.OSUSER,
       s.MACHINE,
       s.STATUS,
       s.PROGRAM,
       st.NAME,
       round(ss.VALUE/1024/1024, 2)size_mb,
       ss.STATISTIC#
  from v$session s, v$sesstat ss, v$statname st
 where ss.SID = s.SID
   and st.STATISTIC# = ss.STATISTIC#
   and s.USERNAME is not null
   and s.OSUSER <> 'oracle'
   and st.NAME = 'redo size'
 order by ss.VALUE desc;
