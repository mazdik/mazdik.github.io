create or replace procedure TABLE_TO_ASS_ARRAY is
/* �������� ������� � ���� �������������� ������� */
  dbmsCURSOR number;
  tbDESC     dbms_sql.desc_tab;
  nCOL_COUNT number;
  nROW_NUM   number;
  sQUERY     varchar2(32767);
  /* �������� ���������(����������) ��� ���������� ������� */
  type tVALUE is record(
    STRVAL  varchar2(4000),
    NUMVAL  number,
    DATEVAL date);
  rVALUE tVALUE;
  /* ������ ���������� �������*/
  type tRESULT_ROWS is table of tVALUE index by varchar(30);
  /* ���������� �������� */
  type tRESULTS is table of tRESULT_ROWS index by binary_integer;
  tbRESULTS tRESULTS;
begin
  /* ������� ������ ����������� */
  tbRESULTS.delete;

  dbmsCURSOR := dbms_sql.open_cursor;
  sQUERY     := 'SELECT * FROM WELL_STATE WHERE ROWNUM <= 3';

  /* ������ ������� */
  dbms_sql.parse(dbmsCURSOR, sQUERY, dbms_sql.native);
  /* ��������� �������� ����������� ������� */
  dbms_sql.describe_columns(dbmsCURSOR, nCOL_COUNT, tbDESC);

  /* ���� �� �������� ������� */
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

  /* ���������� ������� */
  nROW_NUM := dbms_sql.execute(dbmsCURSOR);
  nROW_NUM := 0;
  /* ����� ������ ���������� ������� */
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

  /* �������� dbms ������� */
  dbms_sql.close_cursor(dbmsCURSOR);

  /* ���� ����� ���, �� ������� ������ ������ */
  if (nROW_NUM = 0) then
    for i in 1 .. tbDESC.count loop
      tbRESULTS(1)(tbDESC(i).col_name).STRVAL := null;
    end loop;
  end if;

  /* ������ ����������� (�������: ��������) */
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

  /* ���� */
  if (tbRESULTS.exists(1) and tbRESULTS(1).exists('COL_NAME')) then
    dbms_output.put_line(tbRESULTS(1)('COL_NAME').STRVAL);
  end if;

end TABLE_TO_ASS_ARRAY;
/
