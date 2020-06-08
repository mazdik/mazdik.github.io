--Datafile
RMAN> RESTORE DATAFILE 6;
RMAN> RECOVER DATAFILE 6;

--Restoring Datafiles from Backup to a New Location
RUN
{
  SQL 'ALTER TABLESPACE users OFFLINE IMMEDIATE';
  SQL 'ALTER TABLESPACE tools OFFLINE IMMEDIATE';
  # specify the new location for each datafile
  SET NEWNAME FOR DATAFILE '/olddisk/users01.dbf' TO 
                           '/newdisk/users01.dbf';
  SET NEWNAME FOR DATAFILE '/olddisk/tools01.dbf' TO 
                           '/newdisk/tools01.dbf';
  # to restore to an ASM disk group named dgroup, use: 
  # SET NEWNAME FOR DATAFILE '/olddisk/trgt/tools01.dbf'
  #     TO '+dgroup';
  RESTORE TABLESPACE users, tools;
  SWITCH DATAFILE ALL;   # update control file with new filenames
  RECOVER TABLESPACE users, tools;
}
SQL 'ALTER TABLESPACE users ONLINE';
SQL 'ALTER TABLESPACE tools ONLINE';

--Individual data block
RMAN> BLOCKRECOVER CORRUPTION LIST;
RMAN> BLOCKRECOVER DATAFILE 7 BLOCK 233, 235 DATAFILE 4 BLOCK 101;

--восстановление файла без резервной копии
RMAN> SQL "alter database datafile ''/test01/app/oracle/oradata/remorse/sales01.dbf'' offline";
RMAN> sql "alter database create datafile ''/test01/app/oracle/oradata/remorse/sales01.dbf'' ";
RMAN> RECOVER DATAFILE '/test01/app/oracle/oradata/remorse/sales01.dbf';
RMAN> SQL "alter database datafile ''/test01/app/oracle/oradata/remorse/sales01.dbf'' online";

