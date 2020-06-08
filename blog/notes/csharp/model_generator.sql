SELECT 
(CASE WHEN description IS NOT NULL THEN
'///<summary>' || CHR(13) || CHR(10) ||
'/// ' || description || CHR(13) || CHR(10) || 
'///</summary>' || CHR(13) || CHR(10)
 ELSE '' END) ||
(CASE WHEN pk IS NOT NULL THEN '[Key]' || CHR(13) || CHR(10) ELSE '' END) ||
'public ' ||
CASE 
    WHEN DATA_TYPE IN ('bigint', 'bigserial') THEN 'long'
    WHEN DATA_TYPE = 'binary' THEN 'byte[]'
    WHEN DATA_TYPE IN ('bit', 'boolean') THEN 'bool'
    WHEN DATA_TYPE IN ('char', 'nchar','varchar', 'nvarchar','text', 'ntext', 'character varying', 'national character varying') THEN 'string' 
    WHEN DATA_TYPE = 'date' THEN 'DateTime'
    WHEN DATA_TYPE = 'smalldatetime' THEN 'DateTime'
    WHEN DATA_TYPE IN ('datetime') THEN 'DateTime'
    WHEN DATA_TYPE IN ('datetime2', 'timestamp without time zone') THEN 'DateTime'
    WHEN DATA_TYPE IN ('datetimeoffset', 'timestamp with time zone') THEN 'DateTimeOffset'
    WHEN DATA_TYPE = 'decimal' THEN 'decimal'
    WHEN DATA_TYPE IN ('float', 'double', 'double precision') THEN 'double'
    WHEN DATA_TYPE = 'image' THEN 'byte[]'
    WHEN DATA_TYPE IN ('int', 'integer', 'serial') THEN 'int'
    WHEN DATA_TYPE = 'money' THEN 'decimal'
    WHEN DATA_TYPE = 'numeric' THEN 'decimal'
    WHEN DATA_TYPE = 'real' THEN 'float'
    WHEN DATA_TYPE = 'smallint' THEN 'int'
    WHEN DATA_TYPE = 'smallmoney' THEN 'decimal'
    WHEN DATA_TYPE IN ('time', 'time with timezone', 'time without timezone') THEN 'Time'
    WHEN DATA_TYPE = 'timestamp' THEN 'byte[]'
    WHEN DATA_TYPE = 'tinyint' THEN 'byte'
    WHEN DATA_TYPE IN ('uniqueidentifier', 'uuid') THEN 'Guid'
    WHEN DATA_TYPE IN ('varbinary', 'bytea') THEN 'byte[]'
    WHEN DATA_TYPE = 'xml' THEN 'string'
END || 
CASE WHEN IS_NULLABLE = 'YES' THEN '?' ELSE '' END || ' ' 
|| replace(initcap(replace(COLUMN_NAME, '_', ' ')), ' ', '')
|| ' { get; set; }' AS RESULTS_ROWS
FROM (SELECT c.table_name,
       c.column_name,
       c.data_type,
       c.is_nullable,
       c.ordinal_position,
       (select a.attname
          from pg_index i
          join pg_attribute a
            on a.attrelid = i.indrelid
           and a.attnum = any(i.indkey)
         where i.indrelid = (select oid from pg_class where relname = c.table_name)
           and a.attname = c.column_name
           and i.indisprimary) as pk,
       (select pgd.description
          from pg_catalog.pg_statio_all_tables as st
         inner join pg_catalog.pg_description pgd
            on (pgd.objoid = st.relid)
         inner join information_schema.columns k
            on (pgd.objsubid = k.ordinal_position and k.table_schema = st.schemaname and k.table_name = st.relname)
         where k.table_name = c.table_name
           and k.column_name = c.column_name) as description
  FROM INFORMATION_SCHEMA.COLUMNS c
 WHERE TABLE_NAME = lower('layer')
   AND table_schema = 'era_mer') as V1
ORDER BY ORDINAL_POSITION
/* Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true; */