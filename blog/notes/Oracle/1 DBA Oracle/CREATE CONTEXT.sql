declare 
sCONTEXT constant varchar2( 30 ) := 'PARUS$SESSION$CONTEXT'; 
sPACKAGE constant varchar2( 30 ) := 'PKG_SESSION'; 
OBJECT_NOT_EXIST exception; 
pragma exception_init( OBJECT_NOT_EXIST,-04043 ); 
begin 
/* �������� */ 
begin 
execute immediate 
'DROP CONTEXT '||sCONTEXT; 
exception 
when OBJECT_NOT_EXIST then 
null; 
end; 

/* �������� */ 
execute immediate 
'CREATE CONTEXT '||sCONTEXT||' USING '||sPACKAGE; 
end;

--���
--SQL>DROP CONTEXT PARUS$SESSION$CONTEXT;
--SQL>CREATE CONTEXT PARUS$SESSION$CONTEXT USING PKG_SESSION;
