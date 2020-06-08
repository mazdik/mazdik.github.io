declare --part
no_link EXCEPTION;  /*ADDED THIS LINE*/
PRAGMA EXCEPTION_INIT (no_link, -2081); -- ORA-02081
 
Begin
--body;
EXCEPTION
  WHEN no_link THEN
    RAISE_APPLICATION_ERROR (-20002, 'Sorry, but the database link is not open'); -- your own customized message
end;