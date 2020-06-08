-- Фильтры для NULL
WHERE NVL (a, 0) = NVL (b, 0);
WHERE DECODE (a, b, 'YES', 'NO') = 'YES';
WHERE (a = b OR (a IS NULL AND b IS NULL));
WHERE SYS_OP_MAP_NONNULL(a) = SYS_OP_MAP_NONNULL(b);
--
WHERE (T.WELL_ID = nWELL_ID or nWELL_ID is null)
WHERE (t1.col1 = t2.col2 or coalesce(t1.col1, t2.col2) is null)
WHERE decode(ename, :ename, 1) = 1
WHERE (t.shop_id in (select cdng_id from rpt_cdng) or (select count(cdng_id) from rpt_cdng) = 0)

/* Пример where case */
and (case
         when f.noteop = 1 and sp.deop_date is null then
          1
         when f.noteop = 0 and sp.deop_date >= nvl(f.eop_date, sp.deop_date) then
          1
         when f.noteop is null then
          1
         else
          0
  end) = 1

-- Вывод: ddd. Если все условия ложные, то ничего не выводит
select 'ddd' from dual
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

/* Пример where case | where or */
with W_DATA as
 (select 10002 as STATE_ID, to_date('01.02.2019', 'DD.MM.YYYY') as DT
    from dual
  union all
  select 10002 as STATE_ID, to_date('01.03.2019', 'DD.MM.YYYY') as DT
    from dual
  union all
  select 10001 as STATE_ID, to_date('01.04.2019', 'DD.MM.YYYY') as DT
    from dual)
select *
  from W_DATA
 where
/* 1 способ */
((DT >= to_date('01.03.2019', 'DD.MM.YYYY') and STATE_ID = 10002) or (STATE_ID <> 10002))
/* 2 способ */
 (case
   when STATE_ID = 10002 then
    (case
      when DT >= to_date('01.03.2019', 'DD.MM.YYYY') then
       1
      else
       0
    end)
   else
    1
 end) = 1
