/*
группировка строк в колонки, итоги по колонкам, итоги по строкам (с помощью rollup)
*/
select coalesce(t.product, 'total_sum') as product,
       sum(case when t.supplier = 'A' then t.volume end) as A,
       sum(case when t.supplier = 'B' then t.volume end) as B,
       sum(case when t.supplier = 'C' then t.volume end) as C,
       sum(t.volume) as total_sum
from test_supply t
group by rollup(t.product);
