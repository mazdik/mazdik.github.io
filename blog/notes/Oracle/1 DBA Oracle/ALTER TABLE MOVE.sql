/* ѕеремещение таблицы */
ALTER TABLE ZREPL_MSG_I MOVE;
--parallel
ALTER TABLE ZREPL_MSG_I MOVE NOLOGGING PARALLEL 4;

/* ѕосле MOVE статус индексов станет UNUSABLE  */
SELECT STATUS, INDEX_NAME FROM USER_INDEXES WHERE TABLE_NAME = 'ZREPL_MSG_I';

/* REBUILD индексов */
ALTER INDEX ZREPL_MSG_I_META_IDX REBUILD;
--parallel
ALTER INDEX ZREPL_MSG_I_META_IDX REBUILD PARALLEL 4 NOLOGGING;

/* ѕосле REBUILD статус индексов станет VALID */
SELECT STATUS, INDEX_NAME FROM USER_INDEXES WHERE TABLE_NAME = 'ZREPL_MSG_I';

/* обновл€ем статистику */
begin
DBMS_STATS.GATHER_TABLE_STATS('LIDER','ZREPL_MSG_I');
end;

/* ѕеремещение таблицы в другое табличное пространство */
ALTER TABLE NNNNN MOVE TABLESPACE NNNNN


/*

declare
sTABLE varchar2(100);
begin
sTABLE:='ZREPL_MSG_I';
execute immediate 'ALTER TABLE '||sTABLE||' MOVE';  
begin
for cur_indx in (SELECT STATUS, INDEX_NAME FROM USER_INDEXES WHERE TABLE_NAME = sTABLE)
loop
  execute immediate 'ALTER INDEX '||cur_indx.INDEX_NAME||' REBUILD';
  end loop;
end;
begin
DBMS_STATS.GATHER_TABLE_STATS(user,sTABLE);
end;
end;

*/