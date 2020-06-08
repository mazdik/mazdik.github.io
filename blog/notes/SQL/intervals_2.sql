with W_PURPOSE as
 (select 10100 as WELL_ID,
         10011 as PURPOSE_ID,
         to_date('18.02.2018 00:00', 'dd.mm.yyyy hh24:mi') as BEGIN_DATE,
         to_date('25.02.2019 00:00', 'dd.mm.yyyy hh24:mi') as END_DATE
    from dual
  union all
  select 10100 as WELL_ID,
         10013 as PURPOSE_ID,
         to_date('25.02.2019 00:00', 'dd.mm.yyyy hh24:mi') as BEGIN_DATE,
         to_date('01.01.2100 00:00', 'dd.mm.yyyy hh24:mi') as END_DATE
    from dual),
W_STATE as
 (select 10100 as WELL_ID,
         10001 as STATE_ID,
         to_date('18.02.2018 00:00', 'dd.mm.yyyy hh24:mi') as BEGIN_DATE,
         to_date('26.02.2019 16:00', 'dd.mm.yyyy hh24:mi') as END_DATE
    from dual
  union all
  select 10100 as WELL_ID,
         10002 as STATE_ID,
         to_date('26.02.2019 16:00', 'dd.mm.yyyy hh24:mi') as BEGIN_DATE,
         to_date('26.02.2019 19:00', 'dd.mm.yyyy hh24:mi') as END_DATE
    from dual
  union all
  select 10100 as WELL_ID,
         10010 as STATE_ID,
         to_date('26.02.2019 19:00', 'dd.mm.yyyy hh24:mi') as BEGIN_DATE,
         to_date('01.01.2100 00:00', 'dd.mm.yyyy hh24:mi') as END_DATE
    from dual),
W_TM as
 (select 10100 as WELL_ID, to_date('18.02.2019', 'dd.mm.yyyy') as DT, 111 as ZZZ
    from dual
  union all
  select 10100 as WELL_ID, to_date('25.02.2019', 'dd.mm.yyyy') as DT, 222 as ZZZ
    from dual
  union all
  select 10100 as WELL_ID, to_date('27.02.2019', 'dd.mm.yyyy') as DT, 333 as ZZZ
    from dual)
select *
  from W_TM T, W_PURPOSE P, W_STATE S
 where T.WELL_ID = P.WELL_ID
   and T.WELL_ID = S.WELL_ID
      
   and P.BEGIN_DATE <= T.DT
   and P.END_DATE > T.DT
   and S.BEGIN_DATE <= T.DT
   and S.END_DATE > T.DT
      
   and P.BEGIN_DATE < to_date('01.03.2019', 'dd.mm.yyyy')
   and P.END_DATE > to_date('01.02.2019', 'dd.mm.yyyy')
   and S.BEGIN_DATE < to_date('01.03.2019', 'dd.mm.yyyy')
   and S.END_DATE > to_date('01.02.2019', 'dd.mm.yyyy')
   and S.STATE_ID in (10001, 10010)
   and P.PURPOSE_ID in (10011, 10013)
