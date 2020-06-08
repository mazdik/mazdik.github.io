/* Удаление всех объектов схемы */
BEGIN
  FOR cur_rec IN (SELECT object_name, object_type
                    FROM user_objects
                   WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE', 'TYPE', 'SYNONYM')) LOOP
    BEGIN
      IF cur_rec.object_type = 'TABLE' THEN
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name ||
                          '" CASCADE CONSTRAINTS';
      ELSE
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('FAILED: DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"');
    END;
  END LOOP;
  /* удалить все объекты из корзины текущего пользователя */
  EXECUTE IMMEDIATE 'purge recyclebin';
END;

/* Максимальное значение в коллекции */
declare
  type tNUMS is table of number index by pls_integer;
  tabNUMS tNUMS;
  nMAX    number := 0;
begin
  tabNUMS(0) := 1;
  tabNUMS(1) := 5;
  tabNUMS(2) := 77;
  tabNUMS(3) := 15;
  if (tabNUMS.count > 0) then
    for indx in tabNUMS.first .. tabNUMS.last loop
      if (tabNUMS(indx) > nMAX) then
        nMAX := tabNUMS(indx);
      end if;
    end loop;
  end if;
  dbms_output.put_line(nMAX);
end;

/* Describe REF CURSOR columns */
declare
  l_rcursor sys_refcursor;
  l_colCnt  number;
  l_descTbl dbms_sql.desc_tab;
begin
  open l_rcursor for
    select * from all_users;
  dbms_sql.describe_columns(c => dbms_sql.to_cursor_number(l_rcursor), col_cnt => l_colCnt, desc_t => l_descTbl);
  for i in 1 .. l_colCnt loop
    dbms_output.put_line(l_descTbl(i).col_name);
  end loop;
end;

-- Количество строк кода
select count(*) from all_source T where T.OWNER in ('WELLOP_VD', 'ERA_MER')

-- символов в представлениях
select sum(R.TEXT_LENGTH) from DBA_VIEWS R where R.OWNER in ('WELLOP_VD', 'ERA_MER')

-- Количество строк кода и назначение пакетов
select * from (select T.*, count(*) over(partition by T.NAME) as CNT_LINES from USER_SOURCE T) V1 
where V1.TEXT like '%Purpose%'

-- Контекст сеанса
begin
  DBMS_SESSION.SET_IDENTIFIER('ФИО');
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'ЭРА МЭР', ACTION_NAME => 'insert into orders');
end;
/
select sys_context('userenv', 'module') as module,
       sys_context('userenv', 'client_identifier') as client_identifier,
	   sys_context('USERENV','IP_ADDRESS') as ip
from dual;

/* Конверитровать boolean в varchar2 */
function BOOLEAN_TO_CHAR(bVALUE in boolean) return varchar2 is
begin
return case bVALUE when true then 'TRUE' when false then 'FALSE' else 'NULL' end;
end BOOLEAN_TO_CHAR;

-- WM_CONCAT
select WM_CONCAT(t.COLUMN_NAME) from dba_ind_columns t where t.index_name = 'EVENT_AK'

/* Elapsed time */
declare
  l_cpu number;
  l_ela number;
  l_sysdate                DATE;
begin
  l_cpu := DBMS_UTILITY.GET_CPU_TIME;
  l_ela := DBMS_UTILITY.GET_TIME;
  FOR i in 1 .. 100000 LOOP
    SELECT sysdate into l_sysdate FROM dual;
  END LOOP;
  dbms_output.put_line('CPU: ' || to_char((DBMS_UTILITY.GET_CPU_TIME - l_cpu)/100));
  dbms_output.put_line('Elapsed: ' || to_char((DBMS_UTILITY.GET_TIME - l_ela)/100));
end;

/* Random в пределах процента */
function RAND_PERCENT_CALC(nVALUE in number, nPERCENT in number default 10) return number as
  nRESULT    number;
  nMIN_VALUE number;
  nMAX_VALUE number;
begin
  nMIN_VALUE := nVALUE * (100 - nPERCENT) / 100;
  nMAX_VALUE := nVALUE * (100 + nPERCENT) / 100;
  nRESULT    := dbms_random.value(nMIN_VALUE, nMAX_VALUE);
  return nRESULT;
end RAND_PERCENT_CALC;

--MOVING ALL TABLES FROM USER  
BEGIN
  FOR i IN (
    SELECT * FROM ALL_TABLES where owner = :owner 
      and (tablespace_name is null or tablespace_name != :tbs)
      and temporary != 'Y'
      and partitioned != 'YES'
    ) LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE '  || i.table_name || ' MOVE TABLESPACE ' || :tbs;
  END LOOP; 
END;

--MOVING ALL INDEX
 BEGIN
  FOR i IN (
    SELECT * FROM ALL_TAB_PARTITIONS 
    WHERE table_owner = :owner and tablespace_name != :tbs
  ) LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE ' 
      || i.table_name || ' MOVE PARTITION '
      || i.partition_name ||' TABLESPACE '|| :tbs;
  END LOOP;
END;

--MOVING ALL PARTATION TABLES FROM USER  
BEGIN
  FOR i IN (
    SELECT * FROM ALL_TABLES where owner = :owner and partitioned = 'YES'
  ) LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE '
      || i.table_name || ' MODIFY DEFAULT ATTRIBUTES TABLESPACE ' || :tbs;
  END LOOP;
END;

