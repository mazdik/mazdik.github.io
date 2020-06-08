with T1 as
 (select sysdate - 40 as BEGIN_DATE, sysdate as END_DATE, 1 RN
    from dual
  union all
  select sysdate as BEGIN_DATE, sysdate + 1 as END_DATE, 2 RN
    from dual
  union all
  select sysdate + 1 as BEGIN_DATE, null as END_DATE, 3 RN
    from dual),
T2 as
 (select sysdate - 30 as BEGIN_DATE, sysdate - 1 as END_DATE, 1 RN
    from dual
  union all
  select sysdate - 1 as BEGIN_DATE, sysdate as END_DATE, 2 RN
    from dual
  union all
  select sysdate as BEGIN_DATE, null as END_DATE, 3 RN
    from dual)
select *
  from (select distinct V.BEGIN_DATE
          from (select trunc(sysdate, 'mm') as BEGIN_DATE
                  from T1
                union all
                select BEGIN_DATE
                  from T1
                union all
                select BEGIN_DATE
                  from T2) V
         where V.BEGIN_DATE >= trunc(sysdate, 'mm')
           and V.BEGIN_DATE < trunc(add_months(sysdate, 1), 'mm')) T0
  left outer join T1
    on T0.BEGIN_DATE >= T1.BEGIN_DATE
   and (T0.BEGIN_DATE < T1.END_DATE or T1.END_DATE is null)
  left outer join T2
    on T0.BEGIN_DATE >= T2.BEGIN_DATE
   and (T0.BEGIN_DATE < T2.END_DATE or T2.END_DATE is null)
 order by T0.BEGIN_DATE
/* Аналогично работает и так
T0, T1, T2
where T0.BEGIN_DATE >= T1.BEGIN_DATE
 and (T0.BEGIN_DATE < T1.END_DATE or T1.END_DATE is null)
 and T0.BEGIN_DATE >= T2.BEGIN_DATE
 and (T0.BEGIN_DATE < T2.END_DATE or T2.END_DATE is null)
 */
