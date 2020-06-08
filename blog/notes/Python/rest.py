""" REST API 
in controller:
dept = Blueprint('dept', __name__)

@dept.route('/dept', methods=['GET'])
def get():
    sql = "select * from dept"
    result = get_data_request(sql, request)
    return jsonify(result)
"""
from pkg_common import database, utils
from pkg_common.db_common import get_tab_description, get_primary_keys
import config
import json
import psycopg2
from datetime import datetime


def parse_numeric(value):
    try:
        result = int(value)
        return result
    except ValueError:
        try:
            result = float(value)
            return result
        except ValueError:
            return None


def str_is_date(value):
    try:
        datetime.strptime(value, "%Y-%m-%dT%H:%M:%S")
        return True
    except ValueError:
        try:
            datetime.strptime(value, "%Y-%m-%d")
            return True
        except ValueError:
            return False


def pagination_sorting(query: str,
                       limit: int,
                       page: int,
                       order_field: str,
                       direction: str):
    """ Пагинация и сортировка запроса """
    # Максимальное количество строк результатов SQL
    max_row_count = 500000

    page = 1 if page is None else page
    limit = 50 if limit is None else limit

    row_offset = (page - 1) * limit
    row_count = page * limit
    row_offset = row_offset + 1

    order_clause = ''
    if order_field is not None:
        order_clause = 'order by ' + order_field + ' ' + direction

    if config.DB_VER == config.DB_ORACLE:
        order_clause = 'where rownum <=' + str(max_row_count) + ' ' + order_clause
    else:
        order_clause = order_clause + ' limit ' + str(max_row_count)

    sql = """
    select V4.* from (select V3.*, row_number() over(order by 1) as RN 
    from (select V2.*, count(*) over() as ROW_CNT 
    from (select V1.* from ({0}) V1) V2 {1}) V3) V4 
    where V4.RN between {2} and {3}
    """.format(query, order_clause, row_offset, row_count)
    return sql


def filter_pagin_sort(query: str,
                      limit: int,
                      page: int,
                      order_field: str,
                      direction: str,
                      filters: list,
                      desc_tab: list):
    """ Фильтрация, пагинация и сортировка запроса """
    where = ''
    for fl in filters:
        if fl['name'] in desc_tab:
            if fl['op'] == 'eq':
                if desc_tab[fl['name']] == 'STRING':
                    where = where + ' AND ' + fl['name'] + ' = \'' + fl['val'] + '\''
                elif desc_tab[fl['name']] == 'NUMBER':
                    if parse_numeric(fl['val']):
                        where = where + ' AND ' + fl['name'] + ' = ' + str(fl['val'])
                elif desc_tab[fl['name']] == 'DATE':
                    if str_is_date(fl['val']):
                        where = where + ' AND ' + fl['name'] + '=to_timestamp(\'' + fl[
                            'val'] + '\',\'YYYY-MM-DD"T"HH24:MI:SS\')'
            elif fl['op'] == 'like':
                where = where + ' AND ' + fl['name'] + ' like \'' + fl['val'] + '\''
    query += ' where 1 = 1' + where
    return pagination_sorting(query, limit, page, order_field, direction)


def get_data(process: str,
             limit: int,
             page: int,
             order_field: str,
             direction: str,
             filters: list):
    """ Данные для гридов """
    query = get_query(process)

    sql = filter_pagin_sort(query['sql'], limit, page, order_field, direction, filters, query['desc'])
    conn = database.get_connection()
    cur = conn.cursor()
    cur.execute(sql)
    rows = utils.rows_to_dict_list(cur)
    cur.close()

    num_results = 0
    if len(rows) > 0:
        num_results = rows[0]['row_cnt']
    result = {
        "num_results": num_results,
        "page": page,
        "limit": limit,
        "objects": rows
    }
    return result


def get_data_request(process, request, limit=20):
    page = request.args.get('page')
    page = int(page) if page is not None else 1

    q = request.args.get('q')
    q = json.loads(q) if q else {}
    filters = q['filters'] if ('filters' in q) else {}
    order_by = q['order_by'] if ('order_by' in q) else None

    order_field = order_by[0]['field'] if order_by else None
    direction = order_by[0]['direction'] if order_by else None

    result = get_data(process, limit, page, order_field, direction, filters)
    return result


def cursor_desc_tab(cursor) -> dict:
    """ Метадата курсора """
    desc_tab: dict = {}
    for c in cursor.description:
        column_name = c[0].lower()
        column_type = None
        if config.DB_VER == config.DB_ORACLE:
            type_name = c[1].__name__
            if type_name in ('STRING', 'FIXED_CHAR'):
                column_type = 'STRING'
            elif type_name == 'NUMBER':
                column_type = 'NUMBER'
            elif type_name in ('DATETIME', 'TIMESTAMP'):
                column_type = 'DATE'
            else:
                column_type = 'STRING'
        elif config.DB_VER == config.DB_POSTGRES:
            if c.type_code in psycopg2.extensions.DECIMAL.values:
                column_type = 'NUMBER'
            elif c.type_code in psycopg2.extensions.INTEGER.values:
                column_type = 'NUMBER'
            elif c.type_code in psycopg2.extensions.FLOAT.values:
                column_type = 'NUMBER'
            elif c.type_code in psycopg2.extensions.DATE.values:
                column_type = 'DATE'
            elif c.type_code in psycopg2.DATETIME.values:
                column_type = 'DATE'
            elif c.type_code in psycopg2.STRING.values:
                column_type = 'STRING'
            else:
                column_type = 'STRING'

        desc_tab[column_name] = column_type

    return desc_tab


def get_query(process):
    """ Получить sql процесса """
    query = dict()
    query['sql'] = 'select * from (' + process + ') X'

    sql = utils.prepare_sql(query['sql'])
    conn = database.get_connection()
    cur = conn.cursor()
    cur.execute(sql + ' where 1=2')
    desc_tab = cursor_desc_tab(cur)
    cur.close()
    query['desc'] = desc_tab

    return query
