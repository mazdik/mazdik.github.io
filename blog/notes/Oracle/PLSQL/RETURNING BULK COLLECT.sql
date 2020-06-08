DECLARE
  new_rowid ROWID;
  type tROWID_COLLECTION is table of rowid index by pls_integer;
  tROWIDS tROWID_COLLECTION;
BEGIN
  execute immediate 'UPDATE T_WAPI_LOG SET text = ''sssss'' WHERE type = ''param''' ||
                    ' RETURNING ROWID INTO :1'
    RETURNING BULK COLLECT
    INTO tROWIDS;

  IF tROWIDS.EXISTS(1) THEN
    new_rowid := tROWIDS(1);
    DBMS_OUTPUT.put_line('UPDATE ID=' || new_rowid);
  END IF;

  /* If the collection is empty, FIRST and LAST return NULL. Лучше использовать COUNT */
  FOR i IN 1 .. tROWIDS.COUNT LOOP
    DBMS_OUTPUT.put_line('UPDATE ID=' || tROWIDS(i));
  END LOOP;

  tROWIDS.delete;

  COMMIT;
END;
/

