-- IP from db_links
select t.*,
       REGEXP_SUBSTR(t.host, '\d{1,3}.\d{1,3}.\d{1,3}..\d{1,3}') as ip,
       REGEXP_SUBSTR(t.host, '\d{4,5}') as port,
       REGEXP_SUBSTR(t.host, '[a-zA-Z]{3,10}') as sid
  from all_db_links t

-- Только цифры 169
regexp_replace('W169W', '[^[:digit:]]*')

-- Только буквы WW
regexp_replace('W169W', '[[:digit:]]*')

-- Только первые цифры 169
regexp_substr('169W', '[[:digit:]]*')

-- IS NUMBER
select decode(REGEXP_INSTR('1234', '[^[:digit:]]'),0,'NUMBER','NOT_NUMBER') from dual;

--split string to rows
select regexp_substr('SMITH,ALLEN,WARD,JONES','[^,]+', 1, level) from dual
connect by regexp_substr('SMITH,ALLEN,WARD,JONES', '[^,]+', 1, level) is not null;
--
select level - 1, substr(regexp_substr('/PR0624/MS0707/LU0707', '/[^/]*', 1, level), 2) as OBJ
  from dual
connect by substr(regexp_substr('/PR0624/MS0707/LU0707', '/[^/]*', 1, level), 2) is not null;

/* Послежнее вхождение */
ltrim(regexp_substr(sPUMP_NAME, '(-\d{0,5})$'), '-')
/* 2е вхождение */
ltrim(regexp_substr(sPUMP_NAME, '(-\d{0,5})', 1, 2), '-')

/* Когда нужна уникальность с сортировкой по дате используем регулярку SE0001, SE0000, SE0000 => SE0001, SE0000 */
select regexp_replace((LISTAGG(T.VAL, ',') within group(order by T.DDATE)), '([^,]+)(,\1)+', '\1')
  from (select sysdate - 3 DDATE, 'SE0001' VAL from dual
        union all
        select sysdate - 2, 'SE0000' from dual
        union all
        select sysdate - 1, 'SE0000' from dual) T

-- Excel column name to a number
create or replace function col_alfan(p_col varchar2) return pls_integer is
begin
  return ascii(substr(p_col, -1)) - 64 + nvl((ascii(substr(p_col, -2, 1)) - 64) * 26, 0) + nvl((ascii(substr(p_col, -3, 1)) - 64) * 676, 0);
end;

-- Excel mergeCells
select T.*,
       regexp_substr(CELL1, '[^[:digit:]]{1,3}', 1, 1) as CELL1_COL,
       regexp_substr(CELL1, '[[:digit:]]{1,3}', 1, 1) as CELL1_ROW,
       regexp_substr(CELL2, '[^[:digit:]]{1,3}', 1, 1) as CELL2_COL,
       regexp_substr(CELL2, '[[:digit:]]{1,3}', 1, 1) as CELL2_ROW
  from (select T.MERGE_CELL, regexp_substr(T.MERGE_CELL, '[^:]+', 1, 1) as CELL1, regexp_substr(T.MERGE_CELL, '[^:]+', 1, 2) as CELL2
          from (select 'AS6:AS77' as MERGE_CELL from dual) T) T
