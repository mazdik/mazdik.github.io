select max(id) id, trunc(dsysdate) ddate, count(*) cnt,
count (case when sqlcode like 'OK'  then sqlcode end ) ok,
count (case when sqlcode like '%ORA-%'  then sqlcode end ) ora,
count (case when sqlcode like '%oldbackup%'  then sqlcode end ) oldbackup
from RAD_TOTAL_TABLE t
group by trunc(dsysdate)
order by trunc(dsysdate)
