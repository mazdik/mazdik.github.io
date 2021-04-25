from typing import Callable
from common import postgres_connector


def pg_dwh_iterating(sql: str, params: dict, job: Callable[[list], int], batch_size=10000) -> int:
    sql = format_to_pg_sql(sql)
    rowcount = 0
    rows = []
    columns = pg_cursor_description(sql, params, dwh=True)

    pool = postgres_connector.get_dwh_pool()
    conn = pool.getconn()
    conn.autocommit = False
    try:
        cur = conn.cursor(f'cursor_{config.company_id}')
        cur.execute(sql, params)
        cur.itersize = batch_size

        for row in cur:
            rows.append(dict(zip(columns, row)))
            if len(rows) >= batch_size:
                rowcount += job(rows)
                rows = []

        cur.close()
        rowcount += job(rows)
        rows = []
    finally:
        pool.putconn(conn)
    return rowcount


def pg_cursor_description(sql: str, params: dict, dwh: bool = False) -> list:
    sql = format_to_pg_sql(sql)
    sql = f'select * from ({sql}) v99 where 1=2'
    columns = []
    pool = postgres_connector.get_pool() if not dwh else postgres_connector.get_dwh_pool()
    conn = pool.getconn()
    conn.autocommit = True
    try:
        cur = conn.cursor()
        cur.execute(sql, params)
        columns = [i[0].lower() for i in cur.description]
        cur.close()
    finally:
        pool.putconn(conn)
    return columns
