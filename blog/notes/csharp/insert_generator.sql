SELECT 'insert into ' || TABLE_NAME || ' (' || string_agg(COLUMN_NAME, ', ') || ') values (:' || string_agg(replace(initcap(replace(COLUMN_NAME, '_', ' ')), ' ', ''), ', :') || ')'
FROM (SELECT *
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
 WHERE TABLE_NAME = lower('mer_well_category')
   AND table_schema = 'era_mer') as V1
ORDER BY V1.ORDINAL_POSITION ) V2
group by TABLE_NAME