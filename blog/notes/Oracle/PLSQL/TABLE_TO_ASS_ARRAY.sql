create or replace procedure TABLE_TO_ASS_ARRAY is
/* Получить таблицу в виде ассоциативного массива */
  dbmsCURSOR number;
  tbDESC     dbms_sql.desc_tab;
  nCOL_COUNT number;
  nROW_NUM   number;
  sQUERY     varchar2(32767);
  /* значение параметра(переменной) или результата запроса */
  type tVALUE is record(
    STRVAL  varchar2(4000),
    NUMVAL  number,
    DATEVAL date);
  rVALUE tVALUE;
  /* строки результата запроса*/
  type tRESULT_ROWS is table of tVALUE index by varchar(30);
  /* результаты запросов */
  type tRESULTS is table of tRESULT_ROWS index by binary_integer;
  tbRESULTS tRESULTS;
begin
  /* очистка старых результатов */
  tbRESULTS.delete;

  dbmsCURSOR := dbms_sql.open_cursor;
  sQUERY     := 'SELECT * FROM WELL_STATE WHERE ROWNUM <= 3';

  /* разбор запроса */
  dbms_sql.parse(dbmsCURSOR, sQUERY, dbms_sql.native);
  /* получение описания результатов запроса */
  dbms_sql.describe_columns(dbmsCURSOR, nCOL_COUNT, tbDESC);

  /* цикл по колонкам запроса */
  for i in 1 .. nCOL_COUNT loop
    case tbDESC(i).col_type
      when 1 then
        dbms_sql.define_column(dbmsCURSOR, i, rVALUE.STRVAL, 4000);
      when 2 then
        dbms_sql.define_column(dbmsCURSOR, i, rVALUE.NUMVAL);
      when 12 then
        dbms_sql.define_column(dbmsCURSOR, i, rVALUE.DATEVAL);
    end case;
  end loop;

  /* выполнение запроса */
  nROW_NUM := dbms_sql.execute(dbmsCURSOR);
  nROW_NUM := 0;
  /* выбор данных результата запроса */
  while (dbms_sql.fetch_rows(dbmsCURSOR) > 0) loop
    nROW_NUM := nROW_NUM + 1;
    for i in 1 .. nCOL_COUNT loop
      case tbDESC(i).col_type
        when 1 then
          dbms_sql.column_value(dbmsCURSOR, i, tbRESULTS(nROW_NUM)(tbDESC(i).col_name).STRVAL);
        when 2 then
          dbms_sql.column_value(dbmsCURSOR, i, tbRESULTS(nROW_NUM)(tbDESC(i).col_name).NUMVAL);
        when 12 then
          dbms_sql.column_value(dbmsCURSOR, i, tbRESULTS(nROW_NUM)(tbDESC(i).col_name).DATEVAL);
      end case;
    end loop;
  end loop;

  /* закрытие dbms курсора */
  dbms_sql.close_cursor(dbmsCURSOR);

  /* если строк нет, то создаем пустой массив */
  if (nROW_NUM = 0) then
    for i in 1 .. tbDESC.count loop
      tbRESULTS(1)(tbDESC(i).col_name).STRVAL := null;
    end loop;
  end if;

  /* печать результатов (колонка: значение) */
  for irow in 1 .. tbRESULTS.count loop
    dbms_output.put_line('--- [ROW: ' || irow || '] ---');
    for icol in 1 .. tbDESC.count loop
      case tbDESC(icol).col_type
        when 1 then
          dbms_output.put_line(tbDESC(icol).col_name || ': ' || tbRESULTS(irow)(tbDESC(icol).col_name).STRVAL);
        when 2 then
          dbms_output.put_line(tbDESC(icol).col_name || ': ' || tbRESULTS(irow)(tbDESC(icol).col_name).NUMVAL);
        when 12 then
          dbms_output.put_line(tbDESC(icol).col_name || ': ' || tbRESULTS(irow)(tbDESC(icol).col_name).DATEVAL);
      end case;
    end loop;
  end loop;

  /* тест */
  if (tbRESULTS.exists(1) and tbRESULTS(1).exists('COL_NAME')) then
    dbms_output.put_line(tbRESULTS(1)('COL_NAME').STRVAL);
  end if;

end TABLE_TO_ASS_ARRAY;
/
