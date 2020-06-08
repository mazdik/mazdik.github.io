--Проценты
round((t.s5_30_11 * (100/nullif(t.s5_30_12,0))), 2) as percent,

round((t.s5_30_11 * (100/nullif(nvl(t.s5_30_12,0),0))), 2) as percent,

round(decode(csum,0,0,dsum*(100/csum)), 2) as percent,

round(decode(csum,0,0,(dsum/csum)-1), 2) as percent,

-- RATIO_TO_REPORT (*100)
SELECT last_name, salary, RATIO_TO_REPORT(salary) OVER () AS rr
 FROM employees WHERE job_id = 'PU_CLERK';

LAST_NAME                     SALARY         RR
------------------------- ---------- ----------
Khoo                            3100 .223021583
Baida                           2900 .208633094
Tobias                          2800 .201438849
Himuro                          2600  .18705036
Colmenares                      2500 .179856115

/* Деление */
function CALC_DIVIDE(nDIVIDEND in number, nDIVISOR in number, nROUND in number default 38) return number as
nRESULT number;
begin
if (nDIVISOR <> 0) then
  nRESULT := nDIVIDEND / nDIVISOR;
else
  nRESULT := 0;
end if;
return round(nRESULT, nROUND);
end CALC_DIVIDE;

(case
 when CURRENT_FUND_TIME_M <> 0 then
  round(DJ_VOLUME_M / CURRENT_FUND_TIME_M, 3)
 else
  0
end)
