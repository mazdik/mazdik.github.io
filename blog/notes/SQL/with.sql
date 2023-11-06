with data as (
    select ( select count(*) from oow_demo_items ) items,
        ( select count(*) from oow_demo_store_products where store_id = 10  ) in_store
    from dual
)
select data.in_store||' products / '||data.items||' total' label,
    round( 100 * data.in_store / data.items, 1 )||'%' value,
    round( 100 * data.in_store / data.items ) pct
from data

--Хинт MATERIALIZE создает временную таблицу из подзапроса указанного в with и использует ее в запросе. 
--INLINE же подставляет текст подзапроса в запрос.



/* Перечислить все дни прошлого года и джоинить другую таблицу*/
with x as
 (select level lvl
    from dual
  connect by level <=
             (add_months(trunc(sysdate, 'y'), 12) - trunc(sysdate, 'y'))),
b as
(select add_months(trunc(sysdate, 'y') + lvl - 1, -12) as ddd from x)

select * from b
, R_TABLE_TMP t
where trunc(b.ddd, 'dd')=trunc(t.DOC_DATE(+), 'dd')
order by b.ddd
