declare
  sQUERY      varchar2(32767);
  sON         varchar2(4000);
  sUPDATE     varchar2(8000);
  sCOLUMNS    varchar2(8000);
  sVALUES     varchar2(8000);
  sCRLF       varchar2(2) := CHR(13) || CHR(10);
  sTABLE_NAME varchar2(30) := 'UDAV1';
  iCOUNTER    pls_integer := 0;
  /* массив первичных ключей*/
  type tARRAY is table of varchar2(30) index by varchar2(30);
  tPKEYS tARRAY;
begin
  tPKEYS.delete;
  for cur in (SELECT cols.table_name, cols.column_name, cols.position, cons.status, cons.owner
                FROM user_constraints cons, user_cons_columns cols
               WHERE cons.constraint_type = 'P'
                 AND cons.constraint_name = cols.constraint_name
                 AND cons.owner = cols.owner
                 AND UPPER(cols.table_name) = UPPER(sTABLE_NAME)
               ORDER BY cols.table_name, cols.position) loop
    iCOUNTER := iCOUNTER + 1;
    tPKEYS(cur.column_name) := cur.column_name;
    sON := sON || 'T1.' || cur.column_name || '=T2.' || cur.column_name || ' AND ';
  end loop;
  if (iCOUNTER > 0) then
    sON := rtrim(sON, 'AND ');
    for cur in (select * from user_tab_cols t where t.table_name = sTABLE_NAME) loop
      /* Исключаем первичные ключи */
      if (not tPKEYS.exists(cur.column_name)) then
        sUPDATE := sUPDATE || 'T1.' || cur.column_name || '=T2.' || cur.column_name || ',';
      end if;
      sCOLUMNS := sCOLUMNS || cur.column_name || ',';
      sVALUES  := sVALUES || 'T2.' || cur.column_name || ',';
    end loop;
    sUPDATE  := rtrim(sUPDATE, ',');
    sCOLUMNS := rtrim(sCOLUMNS, ',');
    sVALUES  := rtrim(sVALUES, ',');
    /*  dbms_output.put_line(sON);
    dbms_output.put_line(sUPDATE);
    dbms_output.put_line(sCOLUMNS);
    dbms_output.put_line(sVALUES);*/
    sQUERY := 'MERGE INTO ' || sTABLE_NAME || ' T1 USING' || sCRLF;
    sQUERY := sQUERY || '(SELECT * FROM VV_UDAV WHERE ROWID = ''AAAdhiAAiAAAEw3AAA'') T2' ||
              sCRLF;
    sQUERY := sQUERY || 'ON (' || sON || ')' || sCRLF;
    sQUERY := sQUERY || 'WHEN MATCHED THEN UPDATE SET ' || sCRLF;
    sQUERY := sQUERY || sUPDATE || sCRLF;
    sQUERY := sQUERY || 'WHEN NOT MATCHED THEN ' || sCRLF;
    sQUERY := sQUERY || 'INSERT(' || sCOLUMNS || ')' || sCRLF;
    sQUERY := sQUERY || 'VALUES(' || sVALUES || ')';
    dbms_output.put_line(sQUERY);
  else
    dbms_output.put_line('Table ' || sTABLE_NAME || ' doesn''t have a primary key');
  end if;
end;
