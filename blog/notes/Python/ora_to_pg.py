import os
import re
import logging
from datetime import datetime, timedelta
from typing import List, Tuple
import psycopg2
from psycopg2 import extras as pg_extras


ORACLE_PATH = r'C:\app\instantclient_19_5'
POSTGRES_SCHEMA = 'era_neuro'
EXCLUDE_TABLES = ['dual', 'migration_history', 'tm_measure', 'asutp_in', 'esp_measure']


if ORACLE_PATH not in os.environ['PATH'].split(os.pathsep):
    os.environ['PATH'] += os.pathsep + ORACLE_PATH
# после установки environ импорт cx_Oracle
import cx_Oracle


def get_pg_connection():
    return psycopg2.connect(user='era_neuro', password='era_neuro', dbname='era_neuro', host='localhost', port=5432)


def get_ora_connection():
    return cx_Oracle.connect('ERA_NEURO', 'ERA_NEURO', 'localhost:1521/local')


def format_to_pg_sql(sql: str):
    """ :name -> %(name)s """
    sql = re.sub(r'(:[a-zA-Z_0-9]+)', r'%(\1)s', sql)
    return sql.replace(':', '')


def format_to_pg_sql_no_name(sql: str):
    """ :name -> %s """
    sql = re.sub(r'(:[a-zA-Z_0-9]+)', r'%s', sql)
    return sql.replace(':', '')


def rows_to_dict_list(cursor):
    columns = [i[0].lower() for i in cursor.description]
    return [dict(zip(columns, row)) for row in cursor]


def pg_execute(sql: str, params: dict, connection) -> int:
    sql = format_to_pg_sql(sql)
    rowcount = 0
    connection.autocommit = False
    try:
        cur = connection.cursor()
        cur.execute(sql, params)
        rowcount += cur.rowcount
        connection.commit()
        cur.close()
    except Exception as e:
        logging.exception(e)
        connection.rollback()
    return rowcount


def pg_execute_values(sql: str, records: List[tuple], connection) -> int:
    sql = format_to_pg_sql_no_name(sql)
    # SQL должен быть вида: insert into mytable (id, f1, f2) values (%s, %s, %s)
    rowcount = 0
    connection.autocommit = False
    try:
        cur = connection.cursor()
        pg_extras.execute_batch(cur, sql, records)
        rowcount = len(records)
        cur.close()
        connection.commit()
    except Exception as e:
        logging.exception(e)
        connection.rollback()
    return rowcount


def pg_get_data(sql: str, params: dict, connection) -> list:
    sql = format_to_pg_sql(sql)
    rows = []
    connection.autocommit = True
    try:
        cur = connection.cursor()
        cur.execute(sql, params)
        rows = rows_to_dict_list(cur)
        cur.close()
    except Exception as e:
        logging.exception(e)
        connection.rollback()
    return rows


def pg_get_all_tables(connection, table_schema: str) -> list:
    sql = """
    select t.table_name
    from information_schema.tables t
    where t.table_schema = :table_schema
    and t.table_type = 'BASE TABLE'
    """
    return pg_get_data(sql, {'table_schema': table_schema}, connection)


def ora_get_data(sql: str, params: dict, connection) -> list:
    cur = connection.cursor()
    cur.execute(sql, params)
    rows = rows_to_dict_list(cur)
    cur.close()
    return rows


def ora_get_rows_and_colums(connection, table_name: str) -> Tuple[list, List[str]]:
    sql = 'select * from {0}'.format(table_name)
    rows = ora_get_data(sql, {}, connection)
    colums = list(rows[0].keys()) if len(rows) > 0 else []

    return rows, colums


def ora_to_pg(ora_connection, pg_connection, table_name: str) -> Tuple[int, timedelta]:
    """ Импорт таблицы из оракла в постгрес (truncate + insert) """
    start = datetime.now()

    rows, cols_desc = ora_get_rows_and_colums(ora_connection, table_name)
    count = len(rows)
    if count == 0:
        return 0, datetime.now() - start

    col_names = ', '.join(cols_desc)
    records_list_template = ':' + ', :'.join(cols_desc)
    insert_sql = f'insert into {table_name} ({col_names}) values ({records_list_template})'

    records = [tuple(x.values()) for x in rows]
    pg_execute(f'truncate table {table_name}', {}, pg_connection)
    pg_execute_values(insert_sql, records, pg_connection)

    return count, datetime.now() - start


def ora_to_pg_all_tables(ora_connection, pg_connection, exclude_tables: List[str], schema: str):
    """ Импорт всех таблиц из оракла в постгрес """
    logging.basicConfig(handlers=[logging.StreamHandler()], level=logging.DEBUG, format='%(message)s')

    start = datetime.now()
    pg_execute(f'SET search_path={schema}', {}, pg_connection)
    tables = pg_get_all_tables(pg_connection, schema)

    for table in tables:
        table_name = table['table_name']
        if table_name not in exclude_tables:
            try:
                logging.info(table_name)
                count, elapsed = ora_to_pg(ora_connection, pg_connection, table_name)
                logging.info(f'count rows: {count} | elapsed time: {elapsed}')
            except Exception as e:
                logging.exception('table: %s error: %s', table_name, str(e))

    logging.info('Elapsed time: %s', datetime.now() - start)


def main():
    ora_connection = get_ora_connection()
    pg_connection = get_pg_connection()
    ora_to_pg_all_tables(ora_connection, pg_connection, EXCLUDE_TABLES, POSTGRES_SCHEMA)


if __name__ == "__main__":
    main()
