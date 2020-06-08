/*
Задача о рабочем времени
 id |     start_time      |      stop_time      | work_hrs 
----+---------------------+---------------------+----------
  1 | 2019-03-29 07:00:00 | 2019-04-08 14:00:00 | 58:00:00
  2 | 2019-04-10 07:00:00 | 2019-04-10 20:00:00 | 09:00:00
  3 | 2019-04-11 12:00:00 | 2019-04-12 16:07:12 | 13:07:12
  4 | 2018-12-28 12:00:00 | 2019-01-16 16:00:00 | 67:00:00
*/
with w_periods as
 (select 1 as id,
         to_date('2019-03-29 07:00:00', 'YYYY-MM-DD HH24:MI:SS') as start_time,
         to_date('2019-04-08 14:00:00', 'YYYY-MM-DD HH24:MI:SS') as stop_time
    from dual
  union all
  select 2 as id,
         to_date('2019-04-10 07:00:00', 'YYYY-MM-DD HH24:MI:SS') as start_time,
         to_date('2019-04-10 20:00:00', 'YYYY-MM-DD HH24:MI:SS') as stop_time
    from dual
  union all
  select 3,
         to_date('2019-04-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS') as start_time,
         to_date('2019-04-12 16:07:12', 'YYYY-MM-DD HH24:MI:SS') as stop_time
    from dual
  union all
  select 4,
         to_date('2018-12-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS') as start_time,
         to_date('2019-01-16 16:00:00', 'YYYY-MM-DD HH24:MI:SS') as stop_time
    from dual),
w_holidays as
 (select to_date('2018-01-01', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-01-02', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-01-03', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-01-04', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-01-05', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-01-07', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-01-08', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-02-23', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-03-08', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-03-09', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-04-30', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-05-01', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-05-02', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-05-09', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-06-11', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-06-12', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-11-05', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-12-31', 'YYYY-MM-DD') as dt
	from dual
  union all
  select to_date('2019-01-01', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-01-02', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-01-03', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-01-04', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-01-07', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-01-08', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-02-23', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-03-08', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-05-01', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-05-02', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-05-03', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-05-09', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-05-10', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-06-12', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2019-11-04', 'YYYY-MM-DD') as dt
    from dual),
w_work_days as
 (select to_date('2018-04-28', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-06-09', 'YYYY-MM-DD') as dt
    from dual
  union all
  select to_date('2018-12-29', 'YYYY-MM-DD') as dt
    from dual),
w_dates1 as
 (select v2.id, (count(v2.id) * 9) as work_hrs
    from (select v1.*
            from (select distinct (trunc(p.start_time) + level) as dt, p.id
                    from w_periods p
                   where trunc(p.stop_time - p.start_time) > 1
                  connect by level < trunc(p.stop_time - p.start_time)) v1
           where v1.dt not in (select dt from w_holidays)
             and (trim(to_char(v1.dt, 'DAY')) not in ('SATURDAY', 'SUNDAY') or v1.dt in (select dt from w_work_days))) v2
   group by v2.id),
w_dates2 as
 (select v1.id,
         (case
           when (v1.start_time1 = v1.stop_time1) and (v1.start_time2 = v1.stop_time2) then
            (v1.start_time2 - v1.start_time1)
           else
            (v1.start_time2 - v1.start_time1) + (v1.stop_time2 - v1.stop_time1)
         end) * 24 as work_hrs
    from (select t.*,
                 (case
                   when (t.start_time < trunc_start_time + interval '10' hour) then
                    trunc_start_time + interval '10' hour
                   else
                    t.start_time
                 end) as start_time1,
                 (case
                   when (t.start_time < trunc_start_time + interval '19' hour) then
                    trunc_start_time + interval '19' hour
                   else
                    t.start_time
                 end) as start_time2,
                 (case
                   when (t.stop_time > trunc_stop_time + interval '10' hour) then
                    trunc_stop_time + interval '10' hour
                   else
                    t.stop_time
                 end) as stop_time1,
                 (case
                   when (t.stop_time > trunc_stop_time + interval '19' hour) then
                    trunc_stop_time + interval '19' hour
                   else
                    t.stop_time
                 end) as stop_time2
            from (select x.*, trunc(x.start_time) as trunc_start_time, trunc(x.stop_time) as trunc_stop_time from w_periods x) t) v1)
select p.*, v2.work_hrs
  from (select v1.id, sum(work_hrs) as work_hrs from (select * from w_dates1 union all select * from w_dates2) v1 group by v1.id) v2,
       w_periods p
 where v2.id = p.id
 order by p.id
