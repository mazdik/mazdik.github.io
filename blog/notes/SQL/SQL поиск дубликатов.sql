--поиск дубликатов
select name, count(name) as num from character_votes group by name having num>1 order by num desc;

--удаление дубликатов
delete t1 from character_votes t1, character_votes t2 where t1.name=t2.name and t1.id>t2.id;

--поиск дубликатов 2 способ
select * from character_votes where name in (select name from character_votes group by name having count(*) > 1) order by name;

--поиск дубликатов 3 по нескольким пол¤м
select * from libr_records 
where (datevid,formno, invno) in (
    SELECT datevid,formno, invno
    FROM libr_records
    group by datevid,formno, invno
    having count(*)>1
)

-- удаление дубликатов по rowid
delete from RAD_PARAM_TOTAL_TABLE t
 where t.rowid in (SELECT max(rowid)
                     FROM RAD_PARAM_TOTAL_TABLE
                    where param in ('SRV_MODEL', 'SRV_SN', 'ADDRESS')
                    group by link, param
                   having count(*) > 1);

-- вариант с NOT IN. 
delete TEST_DUPLICATE
where duplicate_id not in (
    select min(duplicate_id)
    from TEST_DUPLICATE
    group by value
  );
-- вариант с NOT EXISTS.
delete TEST_DUPLICATE d
where not exists (
    select 1
    from (select min(duplicate_id) duplicate_id
          from TEST_DUPLICATE
          group by value
          ) d2
    where d.duplicate_id = d2.duplicate_id
  );
-- вариант с row_number()
delete TEST_DUPLICATE
where duplicate_id in (
    select duplicate_id, 
           row_number() over (partition by value order by duplicate_id) rw
        from TEST_DUPLICATE
    ) where rw > 1
  );
