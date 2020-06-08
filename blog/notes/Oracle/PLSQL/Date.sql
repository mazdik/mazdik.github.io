/* Запрос перечисление по датам */
select trunc(sysdate-10-1+level) daten from dual
			connect by level <= (sysdate-(sysdate-10));
/*
	28.09.2012
	29.09.2012
	30.09.2012
	01.10.2012
	и т.д
*/

select sysdate-level/(24*60*60) daten from dual
      connect by level <= (sysdate-(sysdate-24*60*60));
/*
	01.12.2013 22:22:41
	01.12.2013 22:22:40
	01.12.2013 22:22:39
	и т.д
*/

select trunc(sysdate+1)-level/(24*60*60) daten from dual
      connect by level <= (sysdate-(sysdate-24*60*60))  
/*  
	01.12.2013 23:59:59
	01.12.2013 23:59:58
	...
	01.12.2013 0:00:01
	01.12.2013(0:00:00)	
*/

-- 635 дней
with x as
 (select level lvl
    from dual
  connect by level <=
             (add_months(trunc(sysdate, 'y'), 12) - trunc(sysdate, 'y')))
select trunc(sysdate, 'y') + lvl - 1 from x

/* Как подсчитать, сколько раз в году повторяется каждый день недели */
with x as
 (select level lvl
    from dual
  connect by level <=
             (add_months(trunc(sysdate, 'y'), 12)-trunc(sysdate, 'y')))
select to_char(trunc(sysdate, 'y') + lvl-1, 'DAY'), count(*)
  from x
 group by to_char(trunc(sysdate, 'y') + lvl-1, 'DAY')
 
/* Список дней месяца */
select to_date('01.2013', 'mm.yyyy')+level-1 dDATE from  dual
connect by level <= extract(day from add_months(to_date('01.01.2013', 'dd.mm.yyyy'), 1) -1);

/* Количество дней */
SELECT EXTRACT(DAY FROM LAST_DAY(SYSDATE)) num_of_days FROM dual;
/
SELECT TO_CHAR(LAST_DAY(SYSDATE), 'DD') num_of_days FROM dual;
/
SELECT SYSDATE, LAST_DAY(SYSDATE) "Last", LAST_DAY(SYSDATE) - SYSDATE "Days left" FROM dual;
/
select extract(day from add_months(to_date('01.02.2013', 'dd.mm.yyyy'), 1) -1) from dual;

/* Как определить количество дней в году */
select add_months(trunc(sysdate, 'y'), 12) - trunc(sysdate, 'y') from dual

/* Период 01.01-31.12 за прошлый год */
select add_months(trunc(sysdate, 'y'), -12), trunc(sysdate, 'y') - 1 from dual

/* Перечисление по часам */
SELECT LEVEL,
       TO_DATE(TO_CHAR(EXTRACT(DAY FROM SYSDATE), '09') ||
               TO_CHAR(EXTRACT(MONTH FROM SYSDATE), '09') ||
               TO_CHAR(EXTRACT(YEAR FROM SYSDATE), '9999') || TO_CHAR(LEVEL - 1, '09'),
               'DD.MM.YYYY HH24') mon_day
  FROM dual
 WHERE ROWNUM <= 24
CONNECT BY LEVEL = ROWNUM;

/* Список дней месяца */
SELECT LEVEL,
       TO_DATE(TO_CHAR(LEVEL, '09')||
               TO_CHAR(EXTRACT(MONTH FROM SYSDATE), '09')||
               TO_CHAR(EXTRACT(YEAR FROM SYSDATE), '9999'), 
       'dd.mm.yyyy') mon_day
FROM dual
WHERE ROWNUM <= EXTRACT(DAY FROM LAST_DAY(SYSDATE))
CONNECT BY LEVEL=ROWNUM;

/* Список дней месяца */
SELECT LEVEL, LAST_DAY(SYSDATE)-LEVEL+1, 
       LAST_DAY(ADD_MONTHS(SYSDATE, -1))+LEVEL
FROM dual
WHERE ROWNUM <= EXTRACT(DAY FROM LAST_DAY(SYSDATE))
CONNECT BY LEVEL=ROWNUM;

/* На начало года, на весь период */
sum(case
   when T.DDATE between trunc(dDATE_IN, 'y') and
		add_months(trunc(dDATE_IN, 'y'), 12) - 1 then
	T.VALUE_MONTH
 end),
sum(T.VALUE_MONTH)

/* Время из интервала */
select substr(to_char(numtodsinterval(sysdate + 1.21 - sysdate, 'HOUR'), 'HH24:MI:SS'), 12, 8)
  from dual;

/* Последний день года */
add_months(trunc(sysdate,'YEAR'),12)-1

/* Начало следующего месяца */
trunc(last_day(sysdate)+1, 'mm')

/* Последовательность месяцев  */
select add_months(trunc(sysdate, 'Y'), level - 1) from dual connect by level <= 12

/* Количество дней с начала года */
select add_months(trunc(to_date('01.06.2016', 'DD.MM.YYYY'), 'mm'), 1) - trunc(sysdate, 'y') from dual

/* Перечисление дат через каждые 5 дней (1 вариант) */
select daten
  from (select trunc(to_date('21.09.2016', 'DD.MM.YYYY') + level) daten, mod(level, 6) ml
          from dual
        connect by level < (to_date('01.11.2016', 'DD.MM.YYYY') - (to_date('21.09.2016', 'DD.MM.YYYY'))))
 where ml = 0
/* Перечисление дат через каждые 5 дней (2 вариант) */
with ti as
 (select to_date('21.09.2016', 'dd.mm.yyyy') bd,
         to_date('01.11.2016', 'dd.mm.yyyy') ed,
         to_date('01.11.2016', 'dd.mm.yyyy') - to_date('21.09.2016', 'dd.mm.yyyy') + 1 d
    from dual),
pd as
 (select ti.bd + level * 6 dd, level l from ti connect by level * 6 < ti.d)
select * from pd

/* Прибавить время к дате */
select sysdate + 1 / (24 * 60 * 60), -- 1 секунда
       sysdate + 1 / (24 * 60), -- 1 минута
       sysdate + 1 / 24, -- 1 час
       sysdate + 1, -- 1 день
       add_months(sysdate, 1), -- 1 месяц
       add_months(sysdate, 12), -- 1 год
       sysdate + interval '1' second,
       sysdate + interval '1' minute,
       sysdate + interval '1' hour,
       sysdate + interval '1' day,
       sysdate + interval '1' month,
       sysdate + interval '1' year
  from dual

/* По месяцам */
with W_DATES as
 (select V1.*, MONTHS_BETWEEN(END_DATE, BEGIN_DATE) as CNT_MONTHS
    from (select to_date('01.07.2018', 'DD.MM.YYYY') as BEGIN_DATE, to_date('01.07.2019', 'DD.MM.YYYY') as END_DATE from dual) V1)
select distinct add_months(T.BEGIN_DATE, level - 1) as DT from W_DATES T connect by level <= T.CNT_MONTHS order by DT

