declare
  TYPE ARRAY IS TABLE OF RAD_PARAM_TOTAL_TABLE%ROWTYPE;
  l_data ARRAY;

  CURSOR c IS
    SELECT * FROM RAD_PARAM_TOTAL_TABLE;

BEGIN
  OPEN c;
  LOOP
    FETCH c BULK COLLECT
      INTO l_data; /*LIMIT p_array_size*/
  
    FORALL i IN 1 .. l_data.COUNT
      update RAD_PARAM_TOTAL_TABLE
         set NMONTH = TO_NUMBER(TO_CHAR(DDATE, 'mm'))
       where PID = l_data(i).pid;
  
    EXIT WHEN c%NOTFOUND;
  END LOOP;
  CLOSE c;
END;