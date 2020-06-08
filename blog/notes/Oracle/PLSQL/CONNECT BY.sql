CREATE TABLE EMPL (
       ID         INTEGER PRIMARY KEY,
       NAME    VARCHAR(50),
       PARENT_ID  REFERENCES EMPL
);
INSERT INTO EMPL VALUES (1, 'Директор', NULL);
INSERT INTO EMPL VALUES (2, 'Заместитель по экономике', 1);
INSERT INTO EMPL VALUES (3, 'Заместитель по ИТ', 1);
INSERT INTO EMPL VALUES (4, 'Программист', 3);
INSERT INTO EMPL VALUES (5, 'Программист-стажер', 4);
INSERT INTO EMPL VALUES (6, 'Главный бухгалтер', 1);
INSERT INTO EMPL VALUES (7, 'Бухгалтер 1', 6);
INSERT INTO EMPL VALUES (8, 'Бухгалтер 2', 6);

--Для увеличения производительности, вам потребуется создать индексы на таблицу
CREATE INDEX EMPL_IDX1 ON EMPL (ID, PARENT_ID);
CREATE INDEX EMPL_IDX2 ON EMPL (PARENT_ID, ID);

-- Иерархический запрос
SELECT 
  LPAD(' ', (LEVEL - 1) * 2) || NAME AS H_NAME, 
  ID, 
  PARENT_ID, 
  LEVEL
FROM EMPL
CONNECT BY PRIOR ID = PARENT_ID
START WITH ID = 1;
		  
-- все начиная с par_id IS NULL 
SELECT SYS_CONNECT_BY_PATH(name, '/') AS PATH, id, par_id, r_level, LEVEL
FROM adr_address_voc
CONNECT BY PRIOR ID = par_id
START WITH ID IN (SELECT ID FROM adr_address_voc WHERE par_id IS NULL)

-- Вверх по дереву от элемента id
SELECT id,par_id,r_level,name,dept_id
  FROM adr_address_voc			    
  START WITH adr_address_voc.id = 1000521600
  CONNECT BY adr_address_voc.id = PRIOR adr_address_voc.par_id

-- Вниз по дереву от элемента id
SELECT id,par_id,r_level,name,dept_id
  FROM adr_address_voc			    
  START WITH adr_address_voc.id = 1000521600
  CONNECT BY PRIOR adr_address_voc.id =  adr_address_voc.par_id

/* Строки дерева в колонки */
select substr(regexp_substr(OBJ_PATH, '/[^/]*', 1, 1), 2) as L1,
       substr(regexp_substr(OBJ_PATH, '/[^/]*', 1, 2), 2) as L2,
       substr(regexp_substr(OBJ_PATH, '/[^/]*', 1, 3), 2) as L3
  from (select SYS_CONNECT_BY_PATH(T.OBJ_ID, '/') as OBJ_PATH
          from V_FACT_DATA T
        connect by prior T.ID = T.PARENT_ID
         start with T.ID in (select T.ID from FACT_DATA T where T.PARENT_ID is null))

/* Иерархический SQL (connect by prior) в JSON */
with CONNECT_BY_QUERY as
 (select rownum as RNUM, name as FULL_NAME, level as LVL
    from V_ADM_OBJ
   start with parent is null
  connect by prior id = parent
   order siblings by name)
select case
        /* the top dog gets a left curly brace to start things off */
          when LVL = 1 then
           '{'
        /* when the last level is lower (shallower) than the current level, start a "children" array */
          when LVL - lag(LVL) over(order by RNUM) = 1 then
           ',"children" : [{'
          else
           ',{'
        end || ' "name" : "' || FULL_NAME || '" '
       /* when the next level lower (shallower) than the current level, close a "children" array */
        || case
          when lead(LVL, 1, 1) over(order by RNUM) - LVL <= 0 then
           '}' || rpad(' ', 1 + (-2 * (lead(LVL, 1, 1) over(order by RNUM) - LVL)), ']}')
          else
           null
        end as JSON_SNIPPET
  from CONNECT_BY_QUERY
 order by RNUM;
