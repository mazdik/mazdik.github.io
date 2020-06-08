/* 
Корректировка плана запроса без изменения кода через Stored Outlines (всего 4 способа: Stored Outlines, SQL Profiles, SQL patch, SQL plan baseline).
Stored Outlines подходит для разных версий и редакций Oracle – 9, 10, 11, EE, SE, XE. 
В Oracle 11g функционал Stored Outlines официально объявлен устаревшим, рекомендуется использовать SQL Plan Management (SQL plan baseline).
В некоторых случаях, когда хинт неэффективный, но заменить его оперативно в запросе не представляется возможным (например, чужая разработка), 
имеется возможность, не меняя рабочий запрос в программном модуле, заменить хинт (хинты) в запросе, а также в его подзапросах, 
на эффективный хинт (хинты). Это прием — подмена хинтов (который известен, как использование хранимых шаблонов Stored Outlines). 
Но такая подмена должна быть временным решением до момента корректировки запроса, поскольку постоянная подмена хинта может привести 
к некоторому снижению производительности запроса.
https://docs.oracle.com/cd/E15586_01/server.1111/e16638/outlines.htm
http://oracle-base.com/articles/misc/outlines.php
http://www.fors.ru/upload/magazine/05/http_texts/russia_ruoug_deev_sql_plans.html
*/

/*
63072
36442
72320
*/
--Создание public outline
create public outline FNC_COUNTER_NOZ_OUTLINE4
on 
SELECT /*+ ORDERED FIRST_ROWS*/ COUNTER_END 
FROM (SELECT /*+ ORDERED FIRST_ROWS*/ B.COUNTER_END 
FROM CHEQUE_F A, CHEQUE_LINE_F B 
WHERE A.DOC_ID = :B2 AND A.LINE_ID = B.CHEQUE_ID AND B.NOZZLE_ID = :B1 ORDER BY A.BEGIN_DATE DESC) 
WHERE ROWNUM = 1
/
create public outline FNC_COUNTER_NOZ_OUTLINE3
on
SELECT SUM(DECODE(B.CHEQUE_TYPE,0,1,-1)*ABS(A.QUANTITY_FACT))
FROM CHEQUE_LINE_F A, CHEQUE_F B
WHERE A.DOC_ID = :B2 AND A.NOZZLE_ID = :B1 AND A.CHEQUE_ID = B.LINE_ID
/
create public outline FNC_COUNTER_NOZ_OUTLINE2
on
SELECT SUM(A.QUANTITY_FACT)
FROM CHEQUE_LINE_F A, CHEQUE_F B
WHERE A.DOC_ID = :B2 AND A.NOZZLE_ID = :B1 AND A.CHEQUE_ID = B.LINE_ID AND
EXISTS (SELECT 1 FROM CHEQUE_LINE_PAYMENT_F P
WHERE P.DOC_ID = :B2 AND P.CHEQUE_LINE_ID = A.LINE_ID AND P.AMOUNT_CASH = 0)
/
create public outline FNC_COUNTER_NOZ_OUTLINE1
on
SELECT SUM(ROUND(DECODE(B.CHEQUE_TYPE,0,1,-1)*ABS(PCK_AZS_NEW.FNC_GET_CHEQUE_AMOUNT_(B.LINE_ID, A.LINE_ID, 4)+PCK_AZS_NEW.FNC_GET_CHEQUE_AMOUNT_(B.LINE_ID, A.LINE_ID, 2))/A.PRICE,2))
FROM CHEQUE_LINE_F A, CHEQUE_F B
WHERE A.DOC_ID = :B2 AND A.NOZZLE_ID = :B1 AND A.CHEQUE_ID = B.LINE_ID AND A.PRICE <> 0
/
create public outline FNC_COUNTER_NOZ_OUTLINE
on
SELECT COUNTER_END FROM (SELECT /*+ ORDERED FIRST_ROWS*/ B.BEGIN_DATE, A.COUNTER_END
FROM CHEQUE_LINE_F A, CHEQUE_F B
WHERE A.DOC_ID = :B2 AND A.NOZZLE_ID = :B1 AND A.CHEQUE_ID = B.LINE_ID
ORDER BY B.BEGIN_DATE DESC) Z WHERE ROWNUM = 1
/

--проверить UNUSED/USED
select * from dba_outlines 
select * from dba_outline_hints where name = 'FNC_COUNTER_NOZ_OUTLINE4'

-- включить использование public outline, категория DEFAULT
alter system set use_stored_outlines=true;
alter session set use_stored_outlines = true;
-- выключить
alter system set use_stored_outlines=false;
alter session set use_stored_outlines = false;

-- удалить все outline из категории DEFAULT
BEGIN
  DBMS_OUTLN.drop_by_cat (cat => 'DEFAULT');
END;
-- удалить по названию
drop public outline FNC_COUNTER_NOZ_OUTLINE4;

/*
для редактирования хинтов нужно создать private outline.
select * from ol$;
select * from ol$hints;
select * from ol$nodes;
*/
