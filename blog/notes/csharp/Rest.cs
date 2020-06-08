using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using Dapper;

namespace Itsk.Mer.Common
{
    public class SortMetadata
    {
        public string field;
        public int order;
    }

    public class FilterMetadata
    {
        public dynamic value;
        public string matchMode;
        public dynamic valueTo;
        public string type;
    }

    public class PageMetadata
    {
        public int currentPage;
        public int perPage;
        public int maxRowCount;
    }

    public class RequestMetadata
    {
        public PageMetadata pageMeta;
        public SortMetadata[] sortMeta;
        public Dictionary<string, FilterMetadata> filters;
        public string globalFilterValue;
        public string table;
    }

    public enum Dialect
    {
        PostgreSQL,
        Oracle,
    }

    public static class Rest
    {
        /*
        * Максимальное количество строк для этого отчета составляет #MAX_ROW_COUNT# строк.
        * Пожалуйста, примените фильтр, чтобы уменьшить количество записей в запросе.
        */
        public static long maxRowCount = 500000;
        public static Dialect dialect = Dialect.PostgreSQL;

        public const string EQUALS = "equals"; // ==
        public const string NOT_EQUAL = "notEqual"; // !=
        public const string LESS_THAN = "lessThan"; // <
        public const string LESS_THAN_OR_EQUAL = "lessThanOrEqual"; // <=
        public const string GREATER_THAN = "greaterThan"; // >
        public const string GREATER_THAN_OR_EQUAL = "greaterThanOrEqual"; // >=
        public const string IN_RANGE = "inRange"; // 3-7
        public const string IN = "in"; // in
        public const string CONTAINS = "contains"; // like lower(%val%);
        public const string NOT_CONTAINS = "notContains"; // not like lower(%val%);
        public const string STARTS_WITH = "startsWith"; // like val%;
        public const string ENDS_WITH = "endsWith"; // like %val;
        public const string IS_EMPTY = "isEmpty"; // is null
        public const string IS_NOT_EMPTY = "isNotEmpty"; // is not null

        /// <summary>
        /// Данные с фильтрацией, сортировкой и пагинацией
        /// </summary>
        public static object GetRestData(this IDbConnection connection, string query, RequestMetadata request)
        {
            dialect = (connection.GetType().Name == "OracleConnection") ? Dialect.Oracle : Dialect.PostgreSQL;

            var limit = request.pageMeta.perPage == 0 ? 50 : request.pageMeta.perPage;
            var page = request.pageMeta.currentPage == 0 ? 1 : request.pageMeta.currentPage;
            query = "select * from (" + query + ") x";

            DynamicParameters parameters;
            var descTab = GetDescTab(connection, query);
            (query, parameters) = Filtering(query, request.filters, descTab);
            if (!string.IsNullOrEmpty(request.globalFilterValue))
            {
                (query, parameters) = FilteringGlobal(query, request.globalFilterValue, descTab, parameters);
            }
            query = PaginationSorting(query, limit, page, request.sortMeta);

            var rows = connection.Query<object>(query, parameters).ToList();
            object total = 0;
            if (rows.Count > 0)
            {
                var row = rows[0] as IDictionary<string, object>;
                var item = row.Where(x => x.Key.ToLower() == "row_cnt").FirstOrDefault();
                total = item.Value;
            }
            if (dialect == Dialect.Oracle)
            {
                rows = RestHelper.ListObjectLower(rows);
            }
            return new
            {
                items = rows,
                _meta = new
                {
                    totalCount = total,
                    currentPage = page,
                    perPage = limit,
                    maxRowCount,
                }
            };
        }

        /// <summary>
        /// Метадата курсора (типы колонок)
        /// </summary>
        private static Dictionary<string, Type> GetDescTab(IDbConnection connection, string sql)
        {
            var descTab = new Dictionary<string, Type>();
            using (var reader = connection.ExecuteReader(sql + " where 1=2"))
            {
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    descTab.Add(reader.GetName(i).ToLower(), reader.GetFieldType(i));
                }
            }
            return descTab;
        }

        /// <summary>
        ///  Пагинация и сортировка запроса (between, order by)
        /// </summary>
        private static string PaginationSorting(string query, int limit, int page, SortMetadata[] sortMeta)
        {
            var rowOffset = (page - 1) * limit;
            var rowCount = page * limit;
            rowOffset = rowOffset + 1;

            var orderClause = CreateOrderClause(sortMeta);

            if (dialect == Dialect.Oracle)
            {
                orderClause = "where rownum <=" + maxRowCount + " " + orderClause;
            }
            else
            {
                orderClause = orderClause + " limit " + maxRowCount;
            }
            var sql = @"select V4.* from (select V3.*, row_number() over(order by 1) as RN 
             from (select V2.*, count(*) over() as ROW_CNT 
             from (select V1.* from ({0}) V1) V2 {1}) V3) V4 
             where V4.RN between {2} and {3}";
            query = string.Format(sql, query, orderClause, rowOffset, rowCount);
            return query;
        }

        /// <summary>
        /// Фильтрация для запроса (where)
        /// </summary>
        private static (string, DynamicParameters) Filtering(string query, Dictionary<string, FilterMetadata> filters, Dictionary<string, Type> descTab)
        {
            var parameters = new DynamicParameters();
            if (filters == null)
            {
                return (query, parameters);
            }
            string where = string.Empty;
            foreach (var filter in filters)
            {
                var key = filter.Key.ToLower();
                if (descTab.ContainsKey(key))
                {
                    if (descTab[key] == typeof(DateTime))
                    {
                        (where, parameters) = WhereDate(where, parameters, key, filter.Value);
                    }
                    else if (RestHelper.IsNumericType(descTab[key]))
                    {
                        (where, parameters) = WhereNumeric(where, parameters, key, filter.Value);
                    }
                    else
                    {
                        (where, parameters) = WhereString(where, parameters, key, filter.Value);
                    }
                }
            }
            if (!string.IsNullOrEmpty(where))
            {
                query += " where " + where.Substring(4); // remove AND
            }
            return (query, parameters);
        }

        private static (string, DynamicParameters) WhereDate(string where, DynamicParameters parameters, string colName, FilterMetadata filterMeta)
        {
            bool valueIsEmpty = filterMeta.value == null || (filterMeta.value.GetType() == typeof(string) && string.IsNullOrEmpty(filterMeta.value));
            bool valueToIsEmpty = filterMeta.valueTo == null || (filterMeta.valueTo.GetType() == typeof(string) && string.IsNullOrEmpty(filterMeta.valueTo));
            if (valueIsEmpty && filterMeta.matchMode != IN_RANGE)
            {
                return (where, parameters);
            }
            if (!valueIsEmpty)
            {
                filterMeta.value = RestHelper.GetDateTime(filterMeta.value);
            }
            if (!valueToIsEmpty)
            {
                filterMeta.valueTo = RestHelper.GetDateTime(filterMeta.valueTo);
            }

            switch (filterMeta.matchMode)
            {
                case EQUALS:
                    where = where + $" AND {colName} = :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case NOT_EQUAL:
                    where = where + $" AND {colName} != :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case IN_RANGE:
                    if (valueIsEmpty)
                    {
                        where = where + $" AND {colName} < :{colName}";
                        parameters.Add(colName, filterMeta.valueTo);
                    }
                    else if (valueToIsEmpty)
                    {
                        where = where + $" AND {colName} > :{colName}";
                        parameters.Add(colName, filterMeta.value);
                    }
                    else
                    {
                        where = where + $" AND {colName} > :{colName} AND {colName} < :{colName}TO";
                        parameters.Add(colName, filterMeta.value);
                        parameters.Add(colName + "TO", filterMeta.valueTo);
                    }
                    break;
                case LESS_THAN:
                    where = where + $" AND {colName} < :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case LESS_THAN_OR_EQUAL:
                    where = where + $" AND {colName} <= :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case GREATER_THAN:
                    where = where + $" AND {colName} > :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case GREATER_THAN_OR_EQUAL:
                    where = where + $" AND {colName} >= :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case IS_EMPTY:
                    where = where + $" AND {colName} IS NULL";
                    break;
                case IS_NOT_EMPTY:
                    where = where + $" AND {colName} IS NOT NULL";
                    break;
                default:
                    where = where + $" AND {colName} = :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
            }
            return (where, parameters);
        }

        private static (string, DynamicParameters) WhereNumeric(string where, DynamicParameters parameters, string colName, FilterMetadata filterMeta)
        {
            bool valueIsEmpty = filterMeta.value == null || (filterMeta.value.GetType() == typeof(string) && string.IsNullOrEmpty(filterMeta.value));
            bool valueToIsEmpty = filterMeta.valueTo == null || (filterMeta.valueTo.GetType() == typeof(string) && string.IsNullOrEmpty(filterMeta.valueTo));
            if (valueIsEmpty && filterMeta.matchMode != IN_RANGE)
            {
                return (where, parameters);
            }
            if (filterMeta.value.GetType() == typeof(string))
            {
                filterMeta.value = RestHelper.GetDouble(filterMeta.value);
            }

            switch (filterMeta.matchMode)
            {
                case EQUALS:
                    where = where + $" AND {colName} = :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case NOT_EQUAL:
                    where = where + $" AND {colName} != :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case IN:
                    var list = string.Join(",", filterMeta.value);
                    where = where + $" AND {colName} in ({list})";
                    break;
                case IN_RANGE:
                    if (valueIsEmpty)
                    {
                        where = where + $" AND {colName} < :{colName}";
                        parameters.Add(colName, filterMeta.valueTo);
                    }
                    else if (valueToIsEmpty)
                    {
                        where = where + $" AND {colName} > :{colName}";
                        parameters.Add(colName, filterMeta.value);
                    }
                    else
                    {
                        where = where + $" AND {colName} > :{colName} AND {colName} < :{colName}TO";
                        parameters.Add(colName, filterMeta.value);
                        parameters.Add(colName + "TO", filterMeta.valueTo);
                    }
                    break;
                case LESS_THAN:
                    where = where + $" AND {colName} < :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case LESS_THAN_OR_EQUAL:
                    where = where + $" AND {colName} <= :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case GREATER_THAN:
                    where = where + $" AND {colName} > :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case GREATER_THAN_OR_EQUAL:
                    where = where + $" AND {colName} >= :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case IS_EMPTY:
                    where = where + $" AND {colName} IS NULL";
                    break;
                case IS_NOT_EMPTY:
                    where = where + $" AND {colName} IS NOT NULL";
                    break;
                default:
                    where = where + $" AND {colName} = :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
            }
            return (where, parameters);
        }

        private static (string, DynamicParameters) WhereString(string where, DynamicParameters parameters, string colName, FilterMetadata filterMeta)
        {
            bool valueIsEmpty = filterMeta.value == null || (filterMeta.value.GetType() == typeof(string) && string.IsNullOrEmpty(filterMeta.value));
            bool valueToIsEmpty = filterMeta.valueTo == null || (filterMeta.valueTo.GetType() == typeof(string) && string.IsNullOrEmpty(filterMeta.valueTo));
            if (valueIsEmpty && filterMeta.matchMode != IN_RANGE)
            {
                return (where, parameters);
            }

            switch (filterMeta.matchMode)
            {
                case EQUALS:
                    where = where + $" AND {colName} = :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case NOT_EQUAL:
                    where = where + $" AND {colName} != :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
                case IN:
                    var list = string.Empty;
                    if (filterMeta.value.GetType().Name == "JArray")
                    {
                        string[] arr = filterMeta.value.ToObject<string[]>();
                        list = string.Join(",", arr.Select(x => string.Format("'{0}'", x)));
                    }
                    else
                    {
                        list = string.Join(",", filterMeta.value);
                    }
                    where = where + $" AND {colName} in ({list})";
                    break;
                case CONTAINS:
                    where = where + $" AND lower({colName}) LIKE lower(:{colName})";
                    parameters.Add(colName, string.Format("%{0}%", filterMeta.value));
                    break;
                case NOT_CONTAINS:
                    where = where + $" AND lower({colName}) NOT LIKE lower(:{colName})";
                    parameters.Add(colName, string.Format("%{0}%", filterMeta.value));
                    break;
                case STARTS_WITH:
                    where = where + $" AND lower({colName}) LIKE lower(:{colName})";
                    parameters.Add(colName, string.Format("{0}%", filterMeta.value));
                    break;
                case ENDS_WITH:
                    where = where + $" AND lower({colName}) LIKE lower(:{colName})";
                    parameters.Add(colName, string.Format("%{0}", filterMeta.value));
                    break;
                case IS_EMPTY:
                    where = where + $" AND {colName} IS NULL";
                    break;
                case IS_NOT_EMPTY:
                    where = where + $" AND {colName} IS NOT NULL";
                    break;
                default:
                    where = where + $" AND {colName} = :{colName}";
                    parameters.Add(colName, filterMeta.value);
                    break;
            }
            return (where, parameters);
        }

        private static string CreateOrderClause(SortMetadata[] sortMeta)
        {
            string orderClause = string.Empty;

            if (sortMeta != null && sortMeta.Length > 0)
            {
                string orderFields = string.Empty;
                foreach (var sm in sortMeta)
                {
                    var direction = sm.order > 0 ? "asc" : (sm.order < 0 ? "desc" : null);
                    if (direction != null)
                    {
                        orderFields = orderFields + ", " + sm.field + " " + direction;
                    }
                }
                orderClause = (!string.IsNullOrEmpty(orderFields)) ? orderClause = "order by" + orderFields.TrimStart(',') : string.Empty;
            }
            return orderClause;
        }

        /// <summary>
        /// Сквозной поиск по всем колонкам (where)
        /// </summary>
        private static (string, DynamicParameters) FilteringGlobal(string query, string globalFilterValue, Dictionary<string, Type> descTab, DynamicParameters parameters)
        {
            if (globalFilterValue == null)
            {
                return (query, parameters);
            }
            string where = string.Empty;
            foreach (var desc in descTab)
            {
                var colName = desc.Key.ToLower();
                if (desc.Value == typeof(string))
                {
                    where = where + $" OR UPPER({colName}) LIKE UPPER(:GLOBAL_SEARCH_STRING)";
                }
            }
            parameters.Add("GLOBAL_SEARCH_STRING", string.Format("%{0}%", globalFilterValue));
            if (!string.IsNullOrEmpty(where))
            {
                where = where.Substring(3); // remove OR
                var append = parameters.ParameterNames.Count() > 1; // current parameter +
                var literal = append ? "AND" : "WHERE";
                query += " " + literal + " (" + where + ")";
            }
            return (query, parameters);
        }

    }
}
