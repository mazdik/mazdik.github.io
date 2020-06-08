--------------------------------------------------------------------------
https://oracle-base.com/articles/11g/dbms_parallel_execute_11gR2#run_task
--------------------------------------------------------------------------
DECLARE
  l_task     VARCHAR2(30) := 'UPDATE_TM_CHESS';
  l_sql_stmt VARCHAR2(32767);
BEGIN
  DBMS_PARALLEL_EXECUTE.create_task (task_name => l_task);

  DBMS_PARALLEL_EXECUTE.create_chunks_by_rowid(task_name   => l_task,
                                               table_owner => 'CDS',
                                               table_name  => 'TM_CHESS2',
                                               by_row      => TRUE,
                                               chunk_size  => 10000);

  l_sql_stmt := 'update CDS.TM_CHESS2 set dt=dt+1
                 WHERE rowid BETWEEN :start_id AND :end_id';

  DBMS_PARALLEL_EXECUTE.run_task(task_name      => l_task,
                                 sql_stmt       => l_sql_stmt,
                                 language_flag  => DBMS_SQL.NATIVE,
                                 parallel_level => 5);

  --DBMS_PARALLEL_EXECUTE.drop_task(l_task);
END;
--------------------------------------------------------------------------
begin
  for cur in (select task_name from user_parallel_execute_tasks) loop
    DBMS_PARALLEL_EXECUTE.DROP_TASK(cur.task_name);
  end loop;
end;
--------------------------------------------------------------------------
SELECT task_name, status
FROM user_parallel_execute_tasks;

SELECT *
  FROM user_parallel_execute_chunks u
 WHERE u.error_message is not null
ORDER BY chunk_id;

SELECT status, COUNT(*)
FROM   user_parallel_execute_chunks
GROUP BY status
ORDER BY status;

-- ADDITIONAL_INFO
SELECT *
  FROM user_scheduler_job_run_details
 WHERE job_name LIKE (SELECT job_prefix || '%'
                        FROM user_parallel_execute_tasks
                       WHERE task_name = 'UPDATE_TM_CHESS');
