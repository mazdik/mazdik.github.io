-- Фильтры для NULL
WHERE NVL (a, 0) = NVL (b, 0);
WHERE DECODE (a, b, 'YES', 'NO') = 'YES';
WHERE (a = b OR (a IS NULL AND b IS NULL));
--
WHERE (T.WELL_ID = nWELL_ID or nWELL_ID is null)
WHERE (t1.col1 = t2.col2 or coalesce(t1.col1, t2.col2) is null)
WHERE decode(ename, :ename, 1) = 1
WHERE (t.shop_id in (select cdng_id from rpt_cdng) or (select count(cdng_id) from rpt_cdng) = 0)

-- Вывод: ddd. Если все условия ложные, то ничего не выводит
where 
     (case
         when 1 = 1 then
          1
         when 2 = 2 then
          1
         when null is null then
          1
         else
          0
     end) = 1

/* Сквозной поиск */
where (
:P3_SEARCH is null or
(instr(upper(e.ename),upper(:P3_SEARCH) ) > 0 or
instr(upper(e.job),upper(:P3_SEARCH) ) > 0 or
instr(upper(e.deptno),upper(:P3_SEARCH) ) > 0 )
)
