--Удалить неиспользуемые экстенты
ALTER TABLE table_name DEALLOCATE UNUSED;

/*
GENERATED ALWAYS (виртуальный столбец Oracle 11)
Виртуальный столбец — это столбец, который определяется вычислением выражения, 
основанного на одном или более действительных столбцов таблицы, либо функции SQL или PL/SQL.
*/
CREATE TABLE emp_test (
 empno NUMBER(5) PRIMARY KEY,
 ename VARCHAR2(15) NOT NULL,
 ssn NUMBER(9),
 sal NUMBER(7,2),
 hrly_rate NUMBER(7,2) generated always as (sal/2080));

--Parallel CTAS
--Опция PARALLEL позволяет осуществлять загрузку данных параллельно несколькими процессами
CREATE TABLE EMPLOYEE_NEW
 PARALLEL (DEGREE 4)
 AS SELECT * FROM EMPLOYEES
 NOLOGGING;

--таблица только для чтения Oracle 11
ALTER TABLE test READ ONLY;
ALTER TABLE test MOVE;
ALTER TABLE test READ WRITE;

--сжатие таблиц
ALTER TABLE test COMPRESS; --только новые данные бужут сжиматься
ALTER TABLE test UNCOMPRESS; -- не распаковывает уже сжатые ранее данные
ALTER TABLE test NOCOMPRESS;

/*
CREATE CLUSTER
Кластерами называют две или более таблиц, которые физически хранятся вместе, 
чтобы использовать преимущества совпадающих между таблицами столбцов.
*/

-- Временные таблицы в Oracle
CREATE GLOBAL TEMPORARY TABLE sales_info
(customer_name VARCHAR2(30),
transaction_no NUMBER,
transaction_date DATE)
ON COMMIT DELETE ROWS;
--ON COMMIT DELETE ROWS - данные в таблице должны оставаться только на протяжении транзакции
--ON COMMIT PRESERVE ROWS - данные таблицы сохраняются на протяжении сеанса
