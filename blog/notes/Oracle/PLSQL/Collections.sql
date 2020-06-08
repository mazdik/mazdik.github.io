/*
1. Ассоциативный массив (index by table)
2. Varray (variable-size array)
3. Nested table
*/

/* INDEX BY PLS_INTEGER */
DECLARE
   TYPE XX_COST_TYPE IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
   cost XX_COST_TYPE;
   l_res NUMBER;
  BEGIN
   cost(1) := 5 ;
   cost(20) := 10 ;
   cost(12) := 15 ;
   l_res := cost(1) + cost(20) + cost(12);
   DBMS_OUTPUT.PUT_LINE(l_res);
  END;
/* INDEX BY VARCHAR2 */
 DECLARE
  TYPE XX_COST_TYPE IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
  cost XX_COST_TYPE;
  L_SELECTED VARCHAR2(100) := 'CHAIR';
 BEGIN
  cost('TABLE') := 5000;
  cost('CHAIR') := 84020 ;
  cost('LAMP')  := 8300;
  cost('PENCIL'):= 110;
  DBMS_OUTPUT.PUT_LINE(cost(L_SELECTED));
 END;

/* Есть ли значение с таким индексом */
if (tMA.exists(indx - 1)) then
  null;
end if;

/* Коллеция с инициализацией */
type tWELL_DATA is table of tWELL_DATA_RECORD;
tabWELL_DATA tWELL_DATA;

tabWELL_DATA := tWELL_DATA();
tabWELL_DATA.EXTEND;
tabWELL_DATA(tabWELL_DATA.LAST).WELL_ID := 1;

/* Цикл по ассоциативному массиву */
declare
  type tWELL_DATA is record(
    WELL_ID     number,
    VALUE_MONTH number);
  type tbWELL_DATA is table of tWELL_DATA index by varchar2(100);
  tabWELL_DATA tbWELL_DATA;
  sINDX         varchar2(100);
begin
  tabWELL_DATA(7010027700).WELL_ID := 7010027700;
  tabWELL_DATA(7010027700).VALUE_MONTH := nvl(tabWELL_DATA(7010027700).VALUE_MONTH, 0) + 1;
  tabWELL_DATA(7010027700).VALUE_MONTH := nvl(tabWELL_DATA(7010027700).VALUE_MONTH, 0) + 1;

  sINDX := tabWELL_DATA.FIRST;
  while (sINDX is not null) loop
    dbms_output.put_line(tabWELL_DATA(sINDX).VALUE_MONTH);
    sINDX := tabWELL_DATA.NEXT(sINDX);
  end loop;
end;

/* Коллекцию в таблицу CAST/COLLECT/MULTISET/TABLE */
CREATE OR REPLACE TYPE tvendor_site_id_rows IS TABLE OF NUMBER

DECLARE
   -- декларируем
   vendor_site_id_rows tvendor_site_id_rows;
   v_min_val           NUMBER;
   v_max_val           NUMBER;
   v_cnt               NUMBER;
   v_cur               SYS_REFCURSOR;
BEGIN
   -- инициалиируем
   vendor_site_id_rows := tvendor_site_id_rows(1, 3);
   -- в процессе можно что-то добавить/удалить...
   vendor_site_id_rows.extend;
   vendor_site_id_rows(vendor_site_id_rows.count) := 5;
   
   -- далее можно использовать в любых запросах 
   SELECT MIN(t.column_value), MAX(t.column_value), COUNT(*)
     INTO v_min_val, v_max_val, v_cnt
     FROM TABLE(CAST(vendor_site_id_rows AS tvendor_site_id_rows)) t;

   dbms_output.put_line('min - '||v_min_val);
   dbms_output.put_line('max - '||v_max_val);
   dbms_output.put_line('cnt - '||v_cnt);

   -- и в таких
   FOR line IN (SELECT *
                  FROM TABLE(CAST(vendor_site_id_rows AS
                                  tvendor_site_id_rows)))
   LOOP
      dbms_output.put_line('line - '||line.column_value);
   END LOOP;
   
   -- и в открытии курсоров
   OPEN v_cur FOR SELECT *
                  FROM TABLE(CAST(vendor_site_id_rows AS
                                  tvendor_site_id_rows));
   
   -- и в других вариантах запросов ...
END;

/* Через объект */
CREATE TYPE TP_1 AS OBJECT(
     X1 INTEGER,
     X2 VARCHAR2(35),
     X3 DATE);
/     
CREATE TYPE TP_2 AS TABLE OF TP_1;
/
DECLARE
  V TP_2 := TP_2();
BEGIN
  V.EXTEND;
  V(V.LAST) := TP_1(V.COUNT, 'Тест ' || V.COUNT, SYSDATE);
  V.EXTEND;
  V(V.LAST) := TP_1(V.COUNT, 'Тест ' || V.COUNT, SYSDATE);

  FOR cur IN (SELECT * FROM TABLE(CAST(V AS TP_2))) LOOP
    DBMS_OUTPUT.PUT_LINE(cur.X2);
  END LOOP;
END;

/*
Существуют 4 разновидности псевдофункций коллекций:
1. CAST — отображает коллекцию одного типа на коллекцию другого типа. В частности,
может использоваться для отображения VARRAY на вложенную таблицу.
Работа с коллекциями 341
2. COLLECT — агрегирует данные в коллекцию в SQL. Эта функция, впервые появивша-
яся в Oracle Database 10g, была усовершенствована в 11.2 для поддержки упорядо-
чения данных и устранения дубликатов.
3. MULTISET — отображает таблицу базы данных на коллекцию. С псевдофункциями
MULTISET и CAST появляется возможность выборки строки из таблицы базы данных
как из столбца с типом коллекции.
4. TABLE — отображает коллекцию на таблицу базы данных. Функция является об-
ратной по отношению к MULTISET: она возвращает один столбец, содержащий ото-
бражаемую таблицу.
*/


