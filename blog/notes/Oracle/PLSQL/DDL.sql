set serveroutput on
set termout off       
set echo off       
set colsep ''
set linesize 5000  
set heading off    
set feedback off
set trimspool on   
--Выгрузить таблицы 
spool TABLES_NEW.sql
declare
  sDATA varchar2(32767);
  iNUM  pls_integer := 0;
begin
  for cur in (select distinct nvl(T.NEW_TABLE_NAME, T.TABLE_NAME||'_NEW') as TABLE_NAME from WAPI_TAB_COL T order by TABLE_NAME) loop
    iNUM := iNUM + 1;
    begin
      sDATA := ERA_MER.PKG_TRANSFORM.F_GET_TABLE_DDL(cur.table_name, null, null, true);
    exception
      when others then
        sDATA := null;
    end;
    dbms_output.put_line('/* ' || iNUM || ') ' || cur.table_name || ' */');
    dbms_output.put_line(rtrim(sDATA, CHR(13) || CHR(10) || ' ') || ';' || CHR(10));
    sDATA := null;
  end loop;
end;
/

--Выгрузить таблицы проекта
spool TABLES_NEW_PROJECT.sql
declare
  sDATA varchar2(32767);
  iNUM  pls_integer := 0;
begin
  for cur in (select * from USER_TABLES U where U.TABLE_NAME not in (select distinct nvl(T.NEW_TABLE_NAME, T.TABLE_NAME||'_NEW') TABLE_NAME from WAPI_TAB_COL T) order by U.TABLE_NAME) loop
    iNUM := iNUM + 1;
    begin
      sDATA := ERA_MER.PKG_TRANSFORM.F_GET_TABLE_DDL(cur.table_name, null, null, true);
    exception
      when others then
        sDATA := null;
    end;
    dbms_output.put_line('/* ' || iNUM || ') ' || cur.table_name || ' */');
    dbms_output.put_line(rtrim(sDATA, CHR(13) || CHR(10) || ' ') || ';' || CHR(10));
    sDATA := null;
  end loop;
end;
/

--Выгрузить вьюшки DDL 
spool VIEWS.sql
declare
  sDATA varchar2(32767);
  iNUM  pls_integer := 0;
begin
  for cur in (select * from USER_VIEWS V order by V.VIEW_NAME) loop
    iNUM  := iNUM + 1;
    sDATA := ERA_MER.PKG_TRANSFORM.F_GET_VIEW_DDL(cur.view_name);
    dbms_output.put_line('/* ' || iNUM || ') ' || cur.view_name || ' */');
    dbms_output.put_line(rtrim(sDATA, CHR(13) || CHR(10) || ' ') || ';' || CHR(10));
    sDATA := null;
  end loop;
end;
/

--Выгрузить комментарии колонок таблиц
spool COL_COMMENTS.sql
declare
  iNUM pls_integer := 0;
begin
  for cur in (select * from USER_TABLES T order by T.TABLE_NAME) loop
    iNUM := iNUM + 1;
    dbms_output.put_line('/* ' || iNUM || ') ' || cur.table_name || ' */');
    for cur2 in (select * from user_col_comments c where c.table_name = cur.table_name) loop
      if (cur2.comments is not null) then
        dbms_output.put_line('comment on column ' || cur.table_name || '.' || cur2.column_name ||
                             ' is ''' || cur2.comments || ''';');
      end if;
    end loop;
    dbms_output.put_line('');
  end loop;
end;
/

--Выгрузить комментарии таблиц
spool TAB_COMMENTS.sql
declare
  iNUM pls_integer := 0;
begin
  for cur in (select * from USER_TABLES T order by T.TABLE_NAME) loop
    iNUM := iNUM + 1;
    dbms_output.put_line('/* ' || iNUM || ') ' || cur.table_name || ' */');
    for cur2 in (select * from user_tab_comments c where c.table_name = cur.table_name) loop
      if (cur2.comments is not null) then
        dbms_output.put_line('comment on table ' || cur.table_name || ' is ''' || cur2.comments || ''';');
      end if;
    end loop;
    dbms_output.put_line('');
  end loop;
end;
/
exit;

/* Выгрузка структуры таблиц */
select T.TABLE_NAME,
       T.COLUMN_ID,
       T3.COMMENTS,
       T.COLUMN_NAME,
       (case
         when T.DATA_TYPE = 'VARCHAR2' then
          T.DATA_TYPE || '(' || T.DATA_LENGTH || ')'
         else
          T.DATA_TYPE
       end) as DATA_TYPE,
       (case
         when T2.COLUMN_NAME is null then
          F_LONG_TO_CHAR('USER_TAB_COLUMNS', 'DATA_DEFAULT', T.COLUMN_NAME, T.TABLE_NAME)
         else
          'PK Not Null'
       end) as PK_DATA_DEFAULT
  from SYS.USER_TAB_COLS T
  left outer join (select COLS.TABLE_NAME, COLS.COLUMN_NAME
                     from USER_CONSTRAINTS CONS, USER_CONS_COLUMNS COLS
                    where CONS.CONSTRAINT_TYPE = 'P'
                      and CONS.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME) T2
    on T.TABLE_NAME = T2.TABLE_NAME
   and T.COLUMN_NAME = T2.COLUMN_NAME
   left outer join USER_COL_COMMENTS T3
   on T.TABLE_NAME=T3.TABLE_NAME
   and T.COLUMN_NAME=T3.COLUMN_NAME
 where T.TABLE_NAME in (select Z.TABLE_NAME from user_tables Z)
 order by T.TABLE_NAME, T.COLUMN_ID

--DDL over dblink
declare
sSTATMENT varchar2(3000);
begin
sSTATMENT:='create table TEST_TABLE(sslink VARCHAR2(100)) tablespace USERS';
dbms_utility.exec_ddl_statement@db_link(sSTATMENT);
end;
