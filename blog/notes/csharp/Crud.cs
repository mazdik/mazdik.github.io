using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using Dapper;

namespace Itsk.Mer.Common
{
    public class TableDescription
    {
        public string TableName { get; set; }
        public string ColumnName { get; set; }
        public string DataType { get; set; }
        public string Comments { get; set; }
    }

    public class RequestCrud
    {
        public Dictionary<string, object> row;
        public Statement type;
        public string table;
    }

    public enum Statement
    {
       INSERT = 1,
       UPDATE = 2,
       DELETE = 3,
       MERGE = 4
    }

    public static class Crud
    {
        public static Dialect dialect = Dialect.PostgreSQL;

        public static void CrudExec(this IDbConnection connection, RequestCrud data)
        {
            dialect = (connection.GetType().Name == "OracleConnection") ? Dialect.Oracle : Dialect.PostgreSQL;

            var tableName = data.table;
            if (string.IsNullOrEmpty(tableName))
            {
                throw new ArgumentException("Requires a table name");
            }

            var pkeys = GetPrimaryKeys(connection, tableName);
            var colsDesc = GetTabDescription(connection, tableName).Where(x => data.row.ContainsKey(x.ColumnName.ToLower())).ToList();

            var sql = string.Empty;
            if (data.type == Statement.INSERT)
            {
                var idColumn = pkeys.FirstOrDefault().ToLower();
                // если 1 ключ и не задан то исключаем (сиквенс)
                if (pkeys.Count() == 1 && !data.row.ContainsKey(idColumn))
                {
                    sql = CreateInsert(tableName, colsDesc.Where(x => x.ColumnName.ToLower() != idColumn).ToList());
                } else
                {
                    sql = CreateInsert(tableName, colsDesc);
                }
            } else if (data.type == Statement.UPDATE) {
                sql = CreateUpdate(tableName, pkeys, colsDesc);
            } else if (data.type == Statement.DELETE)
            {
                sql = CreateDelete(tableName, pkeys);
            } else if (data.type == Statement.MERGE) {
                sql = CreateMergeSql(tableName, pkeys, colsDesc);
            } else
            {
                return;
            }
            var values = PrepareValues(data.row, colsDesc);
            connection.Execute(sql, values);
        }

        private static string CreateMergeSql(string tableName, List<string> primaryKeys, List<TableDescription> tabDesc)
        {
            return (dialect == Dialect.Oracle) ? CreateOraMergeSql(tableName, primaryKeys, tabDesc) : CreatePgMergeSql(tableName, primaryKeys, tabDesc);
        }

        private static string CreatePgMergeSql(string tableName, List<string> primaryKeys, List<TableDescription> tabDesc)
        {
            var pkeys = string.Join(", ", primaryKeys.ToArray());
            var colsDesc = tabDesc.Select(x => x.ColumnName).ToArray();
            var colNames = string.Join(", ", colsDesc);
            var colNamesExcluded = "EXCLUDED." + string.Join(", EXCLUDED.", colsDesc);
            var recordsListTemplate = ":P_" + string.Join(",:P_", colsDesc).TrimStart(',');
            var sql = string.Format("INSERT INTO {0}({1}) VALUES ({4}) ON CONFLICT({3}) DO UPDATE SET({1}) = ({2})",
                tableName, colNames, colNamesExcluded, pkeys, recordsListTemplate);
            return sql;
        }

        private static string CreateOraMergeSql(string tableName, List<string> primaryKeys, List<TableDescription> tabDesc)
        {
            var where = string.Empty;
            foreach (var key in primaryKeys)
            {
                where += " AND " + key + " = :P_" + key;
            }
            where = where.Substring(5);

            var updateCols = tabDesc.Where(x => !primaryKeys.Any(p => p == x.ColumnName));
            var set = string.Empty;
            foreach (var col in updateCols)
            {
                set += $", {col.ColumnName} = :P_{col.ColumnName}";
            }
            set = set.TrimStart(',');

            var colsDesc = tabDesc.Select(x => x.ColumnName).ToArray();
            var colNames = string.Join(", ", colsDesc);
            var values = ":P_" + string.Join(",:P_", colsDesc).TrimStart(',');

            var sql = string.Format("merge into {0} using DUAL on ({1}) when matched then update set {2} when not matched then insert({3}) values ({4})",
                tableName, where, set, colNames, values);
            return sql;
        }

        private static string CreateInsert(string tableName, List<TableDescription> tabDesc)
        {
            var colsDesc = tabDesc.Select(x => x.ColumnName).ToArray();
            var colNames = string.Join(", ", colsDesc);
            var values = ":P_" + string.Join(",:P_", colsDesc).TrimStart(',');
            var sql = string.Format("INSERT INTO {0}({1}) VALUES ({2})", tableName, colNames, values);
            return sql;
        }

        private static string CreateUpdate(string tableName, List<string> primaryKeys, List<TableDescription> tabDesc)
        {
            var updateCols = tabDesc.Where(x => !primaryKeys.Any(p => p == x.ColumnName));
            var set = string.Empty;
            foreach (var col in updateCols)
            {
                set += $", {col.ColumnName} = :P_{col.ColumnName}";
            }
            set = set.TrimStart(',');

            var where = string.Empty;
            foreach (var key in primaryKeys)
            {
                where += " AND " + key + " = :P_" + key;
            }
            where = where.Substring(5);
            var sql = string.Format("UPDATE {0} SET {1} WHERE {2}", tableName, set, where);
            return sql;
        }

        private static string CreateDelete(string tableName, List<string> primaryKeys)
        {
            var where = string.Empty;
            foreach (var key in primaryKeys)
            {
                where += " AND " + key + " = :P_" + key;
            }
            where = where.Substring(5);
            var sql = string.Format("DELETE FROM {0} WHERE {1}", tableName, where);
            return sql;
        }

        private static List<TableDescription> GetTabDescription(IDbConnection connection, string tableName)
        {
            return (dialect == Dialect.Oracle) ? GetOraTabDescription(connection, tableName) : GetPgTabDescription(connection, tableName);
        }

        private static List<string> GetPrimaryKeys(IDbConnection connection, string tableName)
        {
            return (dialect == Dialect.Oracle) ? GetOraPrimaryKeys(connection, tableName) : GetPgPrimaryKeys(connection, tableName);
        }

        private static List<TableDescription> GetPgTabDescription(IDbConnection connection, string tableName)
        {
            var sql = @"select t1.table_name, t1.column_name, t1.data_type, pgd.description as comments
              from (select c.table_name, c.column_name, c.data_type, c.ordinal_position, st.relid
                      from pg_catalog.pg_statio_all_tables st, information_schema.columns c
                     where c.table_schema = st.schemaname
                       and c.table_name = st.relname
                       and c.table_name = :tableName) t1
              left outer join pg_catalog.pg_description pgd
                on pgd.objoid = t1.relid
               and pgd.objsubid = t1.ordinal_position";
            return connection.Query<TableDescription>(sql, new { tableName }).ToList();
        }

        private static List<string> GetPgPrimaryKeys(IDbConnection connection, string tableName)
        {
            var sql = @"select a.attname
                    from pg_index i
                    join pg_attribute a 
                    on a.attrelid = i.indrelid
                    and a.attnum = any(i.indkey)
                    where i.indrelid = (select oid from pg_class where relname = :tablename)
                    and i.indisprimary";
            return connection.Query<string>(sql, new { tableName }).ToList();
        }

        private static List<TableDescription> GetOraTabDescription(IDbConnection connection, string tableName)
        {
            var sql = @"select lower(T2.TABLE_NAME) as TABLE_NAME, lower(T2.COLUMN_NAME) as COLUMN_NAME, lower(T1.DATA_TYPE) as DATA_TYPE, T2.COMMENTS
              from USER_TAB_COLS T1, USER_COL_COMMENTS T2
             where T1.TABLE_NAME = T2.TABLE_NAME
               and T1.COLUMN_NAME = T2.COLUMN_NAME
               and T1.TABLE_NAME = upper(:tableName)";
            return connection.Query<TableDescription>(sql, new { tableName }).ToList();
        }

        private static List<string> GetOraPrimaryKeys(IDbConnection connection, string tableName)
        {
            string sql = @"select lower(COLS.COLUMN_NAME) as COLUMN_NAME
              from USER_CONSTRAINTS CONS, USER_CONS_COLUMNS COLS
             where CONS.CONSTRAINT_TYPE = 'P'
               and CONS.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME
               and CONS.OWNER = COLS.OWNER
               and upper(COLS.TABLE_NAME) = upper(:tableName)
             order by COLS.TABLE_NAME, COLS.POSITION";
            return connection.Query<string>(sql, new { tableName }).ToList();
        }

        private static Dictionary<string, object> PrepareValues(Dictionary<string, object> row, List<TableDescription> tabDesc)
        {
            var values = new Dictionary<string, object>();
            foreach (var prop in row)
            {
                var key = prop.Key.ToLower();
                var desc = tabDesc.Where(x => x.ColumnName.ToLower() == key).FirstOrDefault();
                if (desc != null)
                {
                    dynamic value;
                    string[] dbDateTypes = { "date", "timestamp", "timestamp without time zone", "timestamp with local time zone" };
                    string[] dbNumberTypes = { "numeric", "smallint", "integer", "bigint", "decimal", "numeric", "real", "double precision", "serial", "bigserial" };
                    if (dbDateTypes.Contains(desc.DataType.ToLower()))
                    {
                        var propVal = Convert.ToString(prop.Value);
                        value = RestHelper.GetDateTime(propVal);
                    } else if (dbNumberTypes.Contains(desc.DataType.ToLower())) {
                        var propVal = Convert.ToString(prop.Value);
                        value = RestHelper.GetDouble(propVal);
                    }
                    else
                    {
                        value = prop.Value;
                    }
                    values.Add("P_" + key.ToLower(), value);
                }
            }
            return values;
        }

    }
}
