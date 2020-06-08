-- Настройка параметров вывода для sqlplus
Set Echo Off Heading On Underline On Recsep Off Feedback off;
Set Linesize 600
Set pagesize 50000
Set Pause Off

-- Выводим в этот файл
spool db_info.txt

col name format a80
col isdefault format a9
col type format a18
col value format a300

-- Список параметров БД
prompt List of database parameters
SELECT name,isdefault, value FROM v$parameter order by num;

-- Список объектов и типов
prompt List of objects and types
SELECT o.object_name, o.object_type, o.status, t.typecode, t.attributes, t.methods
FROM  SYS.ALL_OBJECTS o, SYS.ALL_TYPES t
WHERE o.owner in (<перечень необходимых схем>)
and   o.owner = t.owner
and   o.object_type = 'TYPE'
and   o.object_name = t.type_name
and   o.subobject_name is null
and   t.type_name not like 'SYS@_PLSQL@_%' escape '@' order by 1,2,3,4;

-- Список директорий
prompt List of directories
-- В моей БД нет схем, с наименованием длиннее 20 символов.
col owner format a20
col directory_name format a30
col directory_path format a250
SELECT owner, directory_name, directory_path FROM SYS.ALL_DIRECTORIES
WHERE 1=1 order by 1,2,3;

-- Список пользовательских типов
prompt List of user types
SELECT owner, type_name, typecode
FROM
 SYS.ALL_TYPES WHERE owner in (<перечень необходимых схем>) order by 1,2,3;
 
-- Список пользовательских сиквенсов
prompt List of user sequences
SELECT sequence_owner owner,SEQUENCE_NAME, to_char(MIN_VALUE) min_value, to_char(MAX_VALUE) max_value, INCREMENT_BY, CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE
FROM SYS.ALL_SEQUENCES
WHERE sequence_owner in (<перечень необходимых схем>) order by 1,2,3,4;

-- Список некластеризованных таблиц  
col table_name format a30
col tablespace_name format a30
prompt List of non-cluster tables
SELECT owner,
  TABLE_NAME,
  TABLESPACE_NAME,  
  TEMPORARY, LOGGING, PARTITIONED, NESTED, ROW_MOVEMENT,
  MONITORING, DEPENDENCIES, COMPRESSION, 
  'NO' READ_ONLY, CACHE
FROM ALL_OBJECT_TABLES t
WHERE owner in (<перечень необходимых схем>)
and ((iot_type is null) or (iot_type <> 'IOT_MAPPING'))
and cluster_name is null

union all

SELECT owner,
  TABLE_NAME,
  TABLESPACE_NAME,
  TEMPORARY, LOGGING, PARTITIONED, NESTED, ROW_MOVEMENT,
  MONITORING,  DEPENDENCIES, COMPRESSION, 
  READ_ONLY, CACHE
FROM ALL_TABLES t
WHERE owner in (<перечень необходимых схем>)
and ((iot_type is null) or (iot_type <> 'IOT_MAPPING'))
and cluster_name is null order by 1,2,3,4;

-- Список колонок таблиц
col column_name format a30
prompt List of table columns
SELECT owner,table_name, column_name, data_type,
       decode(data_type, 'CHAR', char_length,
                         'VARCHAR', char_length,
                         'VARCHAR2', char_length,
                         'NCHAR', char_length,
                         'NVARCHAR', char_length,
                         'NVARCHAR2', char_length,
                         data_length) data_length,
       data_precision, data_scale, nullable, char_used
       , virtual_column
FROM SYS.ALL_TAB_COLS c
WHERE OWNER  in (<перечень необходимых схем>)
and   HIDDEN_COLUMN = 'NO'
and exists (SELECT 'x'
            FROM  sys.ALL_ALL_TABLES t
            WHERE t.table_name = c.table_name
            and   t.owner = c.owner)
order by owner,table_name, column_id;

-- Список колонок со значениями по-умолчанию
prompt List of columns with default value 
SELECT owner,TABLE_NAME, COLUMN_NAME, DEFAULT_LENGTH, DATA_DEFAULT
FROM SYS.ALL_TAB_COLUMNS C WHERE OWNER  in (<перечень необходимых схем>)
and default_length is not null order by 1,2,3;

-- Список колонок, являющихся ссылками на объекты
prompt List of REF columns or attributes
SELECT * FROM SYS.ALL_REFS WHERE owner in (<перечень необходимых схем>) order by 1,2,3,4;

-- Список настроек для логирования изменений в таблицах через Streams
prompt List of log group definitions on users table
SELECT c.owner,c.TABLE_NAME, l.LOG_GROUP_NAME, c.COLUMN_NAME, l.ALWAYS
FROM   SYS.ALL_LOG_GROUPS l, SYS.ALL_LOG_GROUP_COLUMNS c
WHERE  l.OWNER = c.OWNER
and    l.owner in (<перечень необходимых схем>)
and    l.LOG_GROUP_NAME = c.LOG_GROUP_NAME
and    l.TABLE_NAME = c.TABLE_NAME
order by c.TABLE_NAME, l.LOG_GROUP_NAME, c.POSITION;

-- Список индексов
col index_name format a30
prompt List of indexes
SELECT OWNER,
   INDEX_NAME,
   INDEX_TYPE,
   TABLE_OWNER,
   TABLE_NAME,
   TABLE_TYPE,
   UNIQUENESS,
   COMPRESSION,
   TABLESPACE_NAME,
   LOGGING,
   STATUS,
   INSTANCES,
   PARTITIONED,
   TEMPORARY,
   GLOBAL_STATS,
   JOIN_INDEX,
   SEGMENT_CREATED FROM SYS.ALL_INDEXES i WHERE owner  in (<перечень необходимых схем>)
and index_type <> 'LOB' order by 1,2,3,4;

-- Список дблинков (общих или в конкретных схемах)
col db_link format a50
col host format a200
prompt List of database links for SELECTed users or public database links
SELECT B.NAME OWNER, A.NAME DB_LINK, A.USERID USERNAME, A.HOST, decode(bitand(a.flag, 1), 1, 'YES', 'NO') shared, a.authusr
FROM SYS.LINK$ A, SYS.USER$ B
WHERE A.OWNER# = B.USER#
and (B.NAME in (<перечень необходимых схем>) OR B.NAME = 'PUBLIC')
order by 1,2,3,4;

-- Список заголовков пакетов
col object_name format a30
col object_type format a20
col status format a10
prompt List of packages
SELECT  owner, object_name, object_type, status
FROM SYS.ALL_OBJECTS WHERE owner in (<перечень необходимых схем>) and OBJECT_TYPE = 'PACKAGE' order by 1,2,3,4;

-- Список тел пакетов
prompt List of package bodies
SELECT owner, object_name, object_type, status FROM SYS.ALL_OBJECTS WHERE owner in (<перечень необходимых схем>) and OBJECT_TYPE = 'PACKAGE BODY'
union all
SELECT distinct owner, s.name, 'PACKAGE BODY', 'VALID'
FROM   sys.all_source s
WHERE  s.type = 'PACKAGE BODY'
and    s.owner in (<перечень необходимых схем>)
and    not exists (SELECT 'x'
                   FROM all_objects o
                   WHERE o.owner = s.owner
                   and o.object_name = s.name
                   and o.object_type = 'PACKAGE BODY') order by 1,2,3,4;

-- Список процедур
prompt List of procedures
SELECT object_name, object_type, status, owner
FROM SYS.ALL_OBJECTS WHERE owner in (<перечень необходимых схем>) and OBJECT_TYPE = 'PROCEDURE' order by 1,2,3,4;

-- Список функций
prompt List of functions
SELECT object_name, object_type, status, owner
FROM SYS.ALL_OBJECTS WHERE owner in (<перечень необходимых схем>) and OBJECT_TYPE = 'FUNCTION' order by 1,2,3,4;

-- Список snapshot логов для материализованных представлений
prompt List of snapshot logs
SELECT *
FROM SYS.ALL_SNAPSHOT_LOGS 
WHERE LOG_OWNER in (<перечень необходимых схем>) order by 1,2,3,4;

-- Список представлений
col view_name format a30
prompt List of views
SELECT v.owner, v.view_name,  o.status, v.view_type_owner, v.view_type, superview_name
FROM SYS.ALL_VIEWS v, SYS.ALL_OBJECTS o
WHERE v.owner = o.owner
and o.object_type = 'VIEW'
and v.view_name = o.object_name
and o.owner in (<перечень необходимых схем>) order by 1,2,3,4;

-- Список колонок представлений
col data_type format a10
col data_type_mod format a10
col data_type_owner format a10
prompt List of view columns
SELECT owner,COLUMN_NAME, DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, TABLE_NAME, DATA_TYPE
FROM SYS.ALL_TAB_COLUMNS C
WHERE OWNER in (<перечень необходимых схем>)
and exists (SELECT 'x'
            FROM   sys.ALL_VIEWS v
            WHERE  v.view_name = c.table_name
            and    v.owner = c.owner)
           and TABLE_NAME not like 'BIN$%'
order by table_name, column_id;

-- Список констрейнтов для представлений
col constraint_name format a30
prompt List of view check constraints
SELECT owner,TABLE_NAME, CONSTRAINT_NAME
FROM   SYS.ALL_CONSTRAINTS
WHERE  owner in (<перечень необходимых схем>)
and    constraint_type = 'V'
and GENERATED = 'USER NAME' order by 1,2;

-- Список триггеров
prompt List of triggers
col trigger_name format a30
col trigger_type format a16
col TRIGGERING_EVENT format a100
SELECT t.owner,T.TRIGGER_NAME, T.TABLE_NAME, T.TRIGGER_TYPE, T.TRIGGERING_EVENT, T.STATUS
FROM SYS.ALL_TRIGGERS t
WHERE t.owner in (<перечень необходимых схем>) order by 1,2,3,4;

-- Список синонимов
col synonym_name format a30
prompt List of synonyms
SELECT * FROM SYS.ALL_SYNONYMS
WHERE ((OWNER in (<перечень необходимых схем>)) OR ((TABLE_OWNER in (<перечень необходимых схем>)) and (OWNER = 'PUBLIC'))) order by 1,2,3,4;

-- Список дименшинов
col dimension_name format a30
prompt List of dimensions
SELECT * FROM SYS.ALL_DIMENSIONS WHERE owner in (<перечень необходимых схем>) order by 1,2,3,4;

-- Список индексированных колонок
prompt List of indexed columns
SELECT INDEX_OWNER OWNER, INDEX_NAME, column_name, COLUMN_LENGTH, TABLE_OWNER, TABLE_NAME, COLUMN_POSITION, DESCEND
FROM SYS.ALL_IND_COLUMNS
WHERE INDEX_OWNER in (<перечень необходимых схем>)
and INDEX_NAME not like 'BIN$%'
ORDER BY INDEX_OWNER, INDEX_NAME, COLUMN_POSITION;

-- Список колонок участвующих в условных битмап индексах
prompt List of join conditions for bitmap indexes
SELECT *
FROM   SYS.ALL_JOIN_IND_COLUMNS
WHERE  INDEX_OWNER in (<перечень необходимых схем>)
order by index_owner, index_name;

-- Список FBI индексов
prompt List of  function based indexes
SELECT IE.INDEX_OWNER OWNER, IE.INDEX_NAME, IE.COLUMN_EXPRESSION, IC.DESCEND,  case when ic.column_name like 'SYS_NC%' THEN 'AUTO GENERATED' ELSE  ic.column_name END column_name
FROM   SYS.ALL_IND_EXPRESSIONS IE, SYS.ALL_IND_COLUMNS IC
WHERE  IE.INDEX_OWNER = IC.INDEX_OWNER
and    IE.INDEX_NAME = IC.INDEX_NAME
and    IE.TABLE_OWNER = IC.TABLE_OWNER
and    IE.TABLE_NAME = IC.TABLE_NAME
and    IE.COLUMN_POSITION = IC.COLUMN_POSITION
and    IC.INDEX_OWNER in (<перечень необходимых схем>)
and    IC.COLUMN_NAME LIKE 'SYS_NC%'
and    IE.INDEX_NAME not like 'BIN$%'
Order by IE.Index_name, IC.column_position;

-- Список комментариев к таблицам
col comments format a300
prompt List of table comments
SELECT OWNER,TABLE_NAME, NULL COLUMN_NAME, comments
FROM   SYS.ALL_TAB_COMMENTS
WHERE  OWNER in (<перечень необходимых схем>)
and    COMMENTS IS NOT NULL and TABLE_NAME not like 'BIN$%'
UNION ALL
SELECT owner,TABLE_NAME, COLUMN_NAME, comments
FROM   SYS.ALL_COL_COMMENTS
WHERE  OWNER in (<перечень необходимых схем>)
and    COMMENTS IS NOT NULL and TABLE_NAME not like 'BIN$%'
UNION ALL
SELECT owner,MVIEW_NAME, NULL COLUMN_NAME,  comments
FROM   SYS.ALL_MVIEW_COMMENTS
WHERE  OWNER in (<перечень необходимых схем>)
and    COMMENTS IS NOT NULL and MVIEW_NAME not like 'BIN$%' order by 1,2;

-- Список условных констрейнтов. Для безыменных добавляется дефолтное имя AUTO GENERATED
prompt List of  check constraints
SELECT c.owner,case when c.constraint_name like 'SYS_C%' THEN 'AUTO GENERATED' ELSE  c.constraint_name END constraint_name, C.TABLE_NAME, CC.COLUMN_NAME, C.SEARCH_CONDITION
FROM   SYS.ALL_CONSTRAINTS c, SYS.ALL_CONS_COLUMNS cc
WHERE  c.OWNER = cc.OWNER
and    c.table_name = cc.TABLE_NAME
and    c.CONSTRAINT_NAME = cc.constraint_name
and    c.constraint_type in ('C', '?')
and    cc.column_name NOT LIKE 'SYS_NC%'
and    c.TABLE_NAME not like 'BIN$%'
and    c.owner in (<перечень необходимых схем>)
and    exists (SELECT owner, table_name, constraint_name  
               FROM   ALL_CONS_COLUMNS cc2
               WHERE  cc2.owner = c.owner
               and    cc2.constraint_name = c.constraint_name
               and    cc2.table_name = c.table_name
               and    cc2.column_name NOT LIKE 'SYS_NC%' -- Без констрейнтов для виртуальных столбцов
               group  by owner, table_name, constraint_name
               having count(*) = 1) order by 1,2,3;

-- Список всех констрейнтов. Для безыменных добавляется дефолтное имя AUTO GENERATED
prompt List of all constraints
SELECT owner,case when constraint_name like 'SYS_C%' THEN 'AUTO GENERATED' ELSE  constraint_name END constraint_name, OWNER, TABLE_NAME, CONSTRAINT_TYPE, SUBSTRB(STATUS, 1, 1) STATUS
, SUBSTRB(DEFERRABLE, 1, 1) deferrable, SUBSTRB(DEFERRED, 1, 1) deferred, SUBSTRB(GENERATED, 1, 1) generated
, RELY
, VALIDATED
, VIEW_RELATED
FROM SYS.ALL_CONSTRAINTS
WHERE OWNER in (<перечень необходимых схем>)
and TABLE_NAME not like 'BIN$%'
and table_name not in (SELECT table_name FROM SYS.ALL_TABLES WHERE owner in (<перечень необходимых схем>) and cluster_name is not null) order by 1,2,3,4;


-- Список колонок, используемых в констрейнтах
prompt List of columns specified in constraints
SELECT owner,case when constraint_name like 'SYS_C%' THEN 'AUTO GENERATED' ELSE  constraint_name END constraint_name, TABLE_NAME, COLUMN_NAME
FROM SYS.ALL_CONS_COLUMNS A
WHERE OWNER in (<перечень необходимых схем>)
and TABLE_NAME not like 'BIN$%'
ORDER BY TABLE_NAME, CONSTRAINT_NAME, POSITION, COLUMN_NAME;

-- Список груп политик безопасности
prompt List of policy groups
SELECT  *
FROM SYS.ALL_POLICY_GROUPS
WHERE object_owner in (<перечень необходимых схем>) order by 1,2,3;

-- Список политик безопасности
col policy_group format a30
col policy_name format a30
col pf_owner format a30
col package format a30
col function format a30
col static_policy format a30
col policy_type format a30
prompt List of policies
SELECT  object_owner owner, object_name, policy_group, policy_name, pf_owner, package, function,sel,ins,upd,del,idx,chk_option,enable,static_policy,policy_type
FROM SYS.ALL_POLICIES
WHERE object_owner in (<перечень необходимых схем>) order by 1,2,3;

-- Список колонок, участвующих в политиках безопасности
prompt List of security relevant columns
SELECT  *
FROM SYS.ALL_SEC_RELEVANT_COLS
WHERE object_owner in (<перечень необходимых схем>) order by 1,2,3;

-- Список привилегий на объекты
prompt List of object grants
SELECT ue.name GRANTEE, u.name OWNER, o.name TABLE_NAME, ur.name GRANTOR, tpm.name PRIVILEGE,
       decode(mod(oa.option$,2), 1, 'YES', 'NO') GRANTABLE,
       decode(bitand(oa.option$,2), 2, 'YES', 'NO') HIERARCHY,
       decode(o.TYPE#, 2, 'TABLE',        4, 'VIEW',
                       6, 'SEQUENCE',     7, 'PROCEDURE',
                       8, 'FUNCTION',     9, 'PACKAGE',
                       13, 'TYPE',       22, 'LIBRARY',
                       23, 'DIRECTORY',  24, 'QUEUE',
                       28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
                       32, 'INDEXTYPE',  33, 'OPERATOR',
                       42, 'MATERIALIZED VIEW',  'UNDEFINED') object_type
FROM sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.table_privilege_map tpm
WHERE oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and u.user# = o.owner#
  and o.TYPE# in (2,4,6,7,8,9,13,22,24,28,29,30,32,33,42)
  and u.name in (<перечень необходимых схем>)
  and o.name not like 'BIN$%'
ORDER BY 1, 2, 3, 5;

-- Список привилегий на колонки
prompt List of column privileges
SELECT * FROM SYS.ALL_COL_PRIVS WHERE TABLE_SCHEMA  in (<перечень необходимых схем>)
ORDER BY grantee, TABLE_SCHEMA, table_name, column_name, privilege;

col REFERENCED_OWNER format a30
col REFERENCED_TYPE format a30
col REFERENCED_NAME format a30
col REFERENCED_LINK_NAME format a30

-- Список зависимостей между объектами. Генерирует очень много строк!!!
prompt List of dependencies between objects
SELECT  owner,NAME object_name, TYPE, REFERENCED_OWNER, REFERENCED_NAME, REFERENCED_TYPE, REFERENCED_LINK_NAME
FROM   SYS.ALL_DEPENDENCIES
WHERE  OWNER  in (<перечень необходимых схем>)
and    OWNER || NAME || TYPE <> REFERENCED_OWNER || REFERENCED_NAME || TYPE
and REFERENCED_NAME not like 'BIN$%'
and   TYPE in ('DIMENSION','FUNCTION','INDEX','MATERIALIZED VIEW','SNAPSHOT','PACKAGE','PACKAGE BODY','PROCEDURE','TRIGGER','TABLE','TYPE','TYPE BODY','VIEW') order by 1,2,3,4;

spool off

exit;