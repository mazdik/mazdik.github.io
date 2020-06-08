/* Секционирование по диапазону ключей */
CREATE TABLE sales_data
 (ticket_no NUMBER,
 sale_year INT NOT NULL,
 sale_month INT NOT NULL,
 sale_day INT NOT NULL)
 PARTITION BY RANGE (sale_year, sale_month, sale_day)
 (PARTITION sales_q1 VALUES LESS THAN (2008, 04, 01)
 TABLESPACE ts1,
 PARTITION sales_q2 VALUES LESS THAN (2008, 07, 01)
 TABLESPACE ts2,
 PARTITION sales_q3 VALUES LESS THAN (2008, 10, 01)
 TABLESPACE ts3,
 PARTITION sales_q4 VALUES LESS THAN (2009, 01, 01)
 TABLESPACE ts4);
 
/* Интервальное секционирование */
CREATE TABLE interval_sales
( prod_id NUMBER(6)
, cust_id NUMBER
, time_id DATE
, channel_id CHAR(1)
, promo_id NUMBER(6)
, quantity_sold NUMBER(3)
, amount_sold NUMBER(10,2)
)
PARTITION BY RANGE (time_id)
INTERVAL(NUMTOYMINTERVAL(1, 'MONTH'))
( PARTITION p0 VALUES LESS THAN (TO_DATE('1-1-2006', 'DD-MM-YYYY')),
PARTITION p1 VALUES LESS THAN (TO_DATE('1-1-2007', 'DD-MM-YYYY')),
PARTITION p2 VALUES LESS THAN (TO_DATE('1-7-2008', 'DD-MM-YYYY')),
PARTITION p3 VALUES LESS THAN (TO_DATE('1-1-2009', 'DD-MM-YYYY')) );

--Секционирование по годам
create table sales (nyear number(4),
                    product varchar2(10),
                    amt number(10,2))
     partition by range (nyear) (
     partition p1 values less than (1992),
     partition p2 values less than (1993),
     partition p3 values less than (1994),
     partition p4 values less than (1995));
--Добавить партишен
ALTER TABLE sales 
   ADD PARTITION p6 VALUES LESS THAN (1996);
--Выборка по партишену p4
select * from sales partition(p4);

select * from sales6 partition for (to_date('15-may-2007','dd-mon-yyyy'));

-- Отделить секцию в отдельную таблицу
alter table partitioned
exchange partition fy_2014
with table fy_2014
including indexes
without validation
UPDATE GLOBAL INDEXES;
-- Удалить партишен
alter table partitioned drop partition fy_2014 UPDATE GLOBAL INDEXES;

-- Присоединить отдельную таблицу к секции
alter taЬle partitioned add partition fy_2016 values less than (to_date('01-01-2017','dd-mm-yyyy');
alter taЬle partitioned
exchange partition fy_2016
with table fy_2016
including indexes
without validation
UPDAТE GLOВAL INDEXES;

/* 11G получает номер партишена из FOR VALUES */
select * from sales partition for (to_date('15-may-2007','dd-mon-yyyy'));
select * from DEBIT_WELL_LAYER partition for ('2016');
/* Секционирование по датам */
create table sales (
sales_id    number,
sales_dt    date
)
partition by range (sales_dt) (
partition p2014 values less than (TO_DATE('01-01-2015', 'DD-MM-YYYY')),
partition p2015 values less than (TO_DATE('01-01-2016', 'DD-MM-YYYY')),
partition p2016 values less than (TO_DATE('01-01-2017', 'DD-MM-YYYY')));

/* Удаление партишенов */
    for el in (
        select p.* from dba_tab_partitions p, dba_segments s
        where
             p.table_owner = 'AUDIT_USER' and p.table_owner = s.owner and
             p.table_name = s.segment_name and p.partition_name = s.partition_name and
             p.partition_name not in (
                 'M'||to_char(curmonth),'M'||to_char(prevm1),'M'||to_char(prevm2),
                 'M'||to_char(prevm3),'M'||to_char(prevm4),'M'||to_char(prevm5),'M'||to_char(prevm6)
             )
    ) loop
        dbms_output.put_line('Drop storage on '||el.table_owner||'.'||el.table_name||'['||el.partition_name||']');
        execute immediate 'alter table '||el.table_owner||'.'||el.table_name||' truncate partition '||el.partition_name||' drop storage';
    end loop;

