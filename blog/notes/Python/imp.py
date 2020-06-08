import os
import psycopg2
import config
from datetime import datetime
import logging

if config.ORACLE_PATH not in os.environ["PATH"].split(os.pathsep):
    os.environ["PATH"] += os.pathsep + config.ORACLE_PATH

import cx_Oracle


def update_progress(count, total, time, name):
    bar_len = 60
    filled_len = int(round(bar_len * count / float(total)))
    percents = round(100.0 * count / float(total), 1)
    bar = '#' * filled_len + '-' * (bar_len - filled_len)

    print("\r{3}({4}/{5}): [{0:50s}] {1:.1f}% ({2})".format(bar, percents, time, name, total, count), end="",
          flush=True)
    if count == total:
        logging.info("{3}({4}/{5}): [{0:50s}] {1:.1f}% ({2})".format(bar, percents, time, name, total, count))


def rows_to_dict_list(cursor):
    """ returns cx_Oracle rows as dicts """
    columns = [i[0] for i in cursor.description]
    return [dict(zip(columns, row)) for row in cursor]


def rows_as_dicts(cursor):
    """ Для чистого способа избежать использования памяти """
    colnames = [i[0] for i in cursor.description]
    for row in cursor:
        yield dict(zip(colnames, row))


def get_primary_keys(conn_ora, table_name):
    cur_ora = conn_ora.cursor()
    select_sql = """
select COLS.COLUMN_NAME
  from USER_CONSTRAINTS CONS, USER_CONS_COLUMNS COLS
 where CONS.CONSTRAINT_TYPE = 'P'
   and CONS.CONSTRAINT_NAME = COLS.CONSTRAINT_NAME
   and CONS.OWNER = COLS.OWNER
   and upper(COLS.TABLE_NAME) = upper(:company)
 order by COLS.TABLE_NAME, COLS.POSITION
    """
    cur_ora.execute(select_sql, {'company': table_name})
    keys = []
    for val in cur_ora:
        keys.append(val[0])
    cur_ora.close()
    return keys


def get_all_tables_pg(conn_pg):
    select_sql = """
    select t.table_name
    from information_schema.tables t
    where t.table_schema = 'era_mer'
    and t.table_type = 'BASE TABLE' 
        """
    cur_pg = conn_pg.cursor()
    cur_pg.execute(select_sql)
    rows = cur_pg.fetchall()
    cur_pg.close()
    rows = [elem[0] for elem in rows]
    return rows


def disable_all_triggers_pg(conn_pg, tables=None):
    if tables is None:
        tables = get_all_tables_pg(conn_pg)
    cur_pg = conn_pg.cursor()
    for table in tables:
        cur_pg.execute('ALTER TABLE {0} DISABLE TRIGGER ALL'.format(table))
    cur_pg.close()


def enable_all_triggers_pg(conn_pg, tables=None):
    if tables is None:
        tables = get_all_tables_pg(conn_pg)
    cur_pg = conn_pg.cursor()
    for table in tables:
        cur_pg.execute('ALTER TABLE {0} ENABLE TRIGGER ALL'.format(table))
    conn_pg.commit()
    cur_pg.close()


def count_rows(conn, table_name):
    sql = 'SELECT count(*) from {0}'.format(table_name)
    cur = conn.cursor()
    cur.execute(sql)
    results = cur.fetchone()
    cur.close()
    return results[0]


def ora_tab_to_pg_tab(conn_ora, conn_pg, table_name):
    index = 0
    start = datetime.now()
    count = count_rows(conn_ora, table_name)
    if count == 0:
        return

    pkeys = get_primary_keys(conn_ora, table_name)
    pkeys = ', '.join(pkeys)

    cur_ora = conn_ora.cursor()
    select_sql = 'select * from {0}'.format(table_name)
    cur_ora.execute(select_sql)

    cols_desc = [col[0] for col in cur_ora.description]
    col_names = ', '.join(cols_desc)
    col_names_excluded = ', EXCLUDED.'.join(cols_desc)
    col_names_excluded = 'EXCLUDED.' + col_names_excluded

    records_list_template = ','.join(['%s'] * len(cols_desc))

    cur_pg = conn_pg.cursor()
    for row in cur_ora:
        upsert_sql = '''
        INSERT INTO {0}({1}) VALUES ({4}) 
        ON CONFLICT ({3}) DO UPDATE SET ({1}) = ({2})
        '''.format(table_name, col_names, col_names_excluded, pkeys, records_list_template)
        cur_pg.execute(upsert_sql, row)
        index += 1
        update_progress(index, count, datetime.now() - start, table_name)
    conn_pg.commit()
    print()

    cur_ora.close()
    cur_pg.close()


def ora_to_pg_all_tables():
    """ Импорт всех таблиц из оракла в постгрес """
    logging.basicConfig(filename='imp.log', level=logging.DEBUG)

    start = datetime.now()
    conn_ora = cx_Oracle.connect(config.DSN_ORA)
    conn_pg = psycopg2.connect(config.DSN_PG)

    cur_pg = conn_pg.cursor()
    cur_pg.execute('SET search_path = era_mer')
    cur_pg.close()

    tables = get_all_tables_pg(conn_pg)

    disable_all_triggers_pg(conn_pg, tables)

    for table in tables:
        ora_tab_to_pg_tab(conn_ora, conn_pg, table)

    enable_all_triggers_pg(conn_pg, tables)

    conn_ora.close()
    conn_pg.close()

    print('Elapsed time: {0}'.format(datetime.now() - start))
    logging.info('Elapsed time: {0}'.format(datetime.now() - start))


ora_to_pg_all_tables()
