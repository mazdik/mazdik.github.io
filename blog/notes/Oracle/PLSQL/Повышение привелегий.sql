create user TEST identified by TEST
grant connect to TEST;
grant create any procedure to TEST;
grant execute any procedure to TEST;

/* Обязательно в схеме SYSTEM иначе будет ошибка ORA-01031: insufficient privileges */
CREATE OR REPLACE procedure SYSTEM.DBATEST 
IS
BEGIN
EXECUTE IMMEDIATE 'GRANT DBA TO TEST';
END;


begin
 SYSTEM.DBATEST;
end;