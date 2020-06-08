/* Конвертация в clob nls_charset_id('AL32UTF8') */
dbms_lob.converttoclob(dest_lob     => lclob_Result,
					 src_blob     => plob,
					 amount       => dbms_lob.lobmaxsize,
					 dest_offset  => l_dest_offsset,
					 src_offset   => l_src_offsset,
					 blob_csid    => nls_charset_id('AL32UTF8'),
					 lang_context => l_lang_context,
					 warning      => l_warning);
/* Сравнить clob */
declare
   c1 clob;
   c2 clob;
begin
select t.clob_txt into c1 from UPD_TABLE t where t.id=82;
select r.clob_txt into c2 from UPD_TABLE r where r.id=6;
  
dbms_output.put_line(DBMS_LOB.getlength(c1));
dbms_output.put_line(DBMS_LOB.getlength(c2));
/* удаляем chr(13) - возврат каретки LF/CR */
c1:=replace(c1, chr(13), '');
dbms_output.put_line(DBMS_LOB.getlength(c1));
dbms_output.put_line(DBMS_LOB.getlength(c2));
/* если 0 то равны*/
dbms_output.put_line(dbms_lob.compare( c1, c2 ) );
end;

/* Печать больших текстов */
str_len := length(sSUBQUERY);
while loop_count < str_len
loop 
  dbms_output.put_line(substr(sSUBQUERY, loop_count+1, 255)); 
  loop_count := loop_count+255; 
end loop; 


