/* Получить значение константы */
function GET_CONSTANT(sCONSTANT_NAME in varchar2) return number deterministic as
nRESULT number;
begin
begin
  execute immediate 'BEGIN :nRESULT := PKG_TESTER.' || sCONSTANT_NAME || '; END;'
	using out nRESULT;
exception
  when others then
	nRESULT := null;
end;
return nRESULT;
end GET_CONSTANT;
