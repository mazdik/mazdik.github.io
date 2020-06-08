/*
select * from TABLE(PIPELINED_TEST.PIPE_LINED);
*/
create or replace package PIPELINED_TEST is

  TYPE ttt_type IS RECORD(
    name0 varchar2(200),
    name1 varchar2(200),
    name2 varchar2(200),
    name3 varchar2(200),
    name4 varchar2(200),
    name5 varchar2(200));

  TYPE ttt_tab IS TABLE OF ttt_type;

  function PIPE_LINED return ttt_tab
    PIPELINED;

end PIPELINED_TEST;
/
create or replace package body PIPELINED_TEST is

  function PIPE_LINED return ttt_tab
    PIPELINED is
    buf  ttt_tab;
    c    sys_refcursor;
    sSQL varchar2(2000);
  begin
    sSQL := 'select ''LINK'', ''NAME'', ''PERCENT'', ''FOUND'', ''ERR'', ''DDATE'' from dual';
  
    open c for sSQL;
    loop
      fetch c bulk collect
        into buf;
    
      for i in 1 .. buf.Count loop
        pipe row(buf(i));
      end loop;
    
      exit when c%NotFound;
    end loop;
    close c;
  end PIPE_LINED;

begin
  null;
end PIPELINED_TEST;
/

/* Удаленный вызов pipelined function через DBLINK */
create or replace view V_REPORT_OIL as
select * from table(PKG_REPORT_OIL.PIPELINED_REPORT(substr(sys_context('userenv', 'client_info'), 9, 1),
                                             to_date(substr(sys_context('userenv', 'client_info'), 1, 8),'yyyymmdd'),
                                             substr(sys_context('userenv', 'client_info'), 10, 6),
                                             substr(sys_context('userenv', 'client_info'), 16, 6)));
/* Передача параметров и получение данных по dblink */
begin
DBMS_APPLICATION_INFO.SET_CLIENT_INFO@TESTV(to_char(sysdate-30,'yyyymmdd') || to_char(1) || 'PR0003' || 'OM0001');
commit;
end;
select * from V_REPORT_OIL@TESTV

/* 2й вариант через GLOBAL TEMPORARY TABLE */
CREATE GLOBAL TEMPORARY TABLE MyPipeFunc_Parameters (
   FromDate DATE,
   ToDate DATE
) ON COMMIT PRESERVE ROWS;
/
CREATE OR REPLACE VIEW vv AS
SELECT * FROM MyPipeFunc_Parameters param,
 TABLE( MyPipeLinefunc(param.FromDate, param.ToDate));
/
DELETE FROM MyPipeFunc_Parameters@DB_B;
INSERT INTO MyPipeFunc_Parameters@DB_B VALUES (SYSDATE, SYSDATE+10);
SELECT * FROM vv@DB_B;

