# stdlib
import enum
from typing import List, Tuple

# thirdparty
from psycopg2 import extensions
from psycopg2 import extras as pg_extras


def execute_values(sql_params_list: List[Tuple[str, List[tuple]]], connection) -> int:
    """
    Массовое добавление/обновление/удаление строк помощью одного оператора

    :param sql_params_list: Список запросов и их параметров
        Пример:
        [
            ("delete from test where (col1, col2, col3) in (%s)", [(1,2,3), (4,5,6)]),
            ("insert into test (col1, col2, col3, col4) values %s", [(1,2,3,4), (5,6,7,8)]),
            ("update test set (col2, col3) = (data.col2, data.col3)
                from (values %s) as data (col1, col2, col3) where test.col1 = data.col1", [(1,2,3), (4,5,6)])
        ]
        Результирующий запрос в бд:
            delete from test where (col1, col2, col3) in ((1,2,3), (4,5,6));
            insert into test (col1, col2, col3, col4) values (1,2,3,4), (5,6,7,8)
                on conflict(col1, col2) do update set(col3, col4) = (excluded.col3, excluded.col4);
            update test set (col2, col3) = (data.col2, data.col3)
                from (values (1,2,3), (4,5,6)) as data (col1, col2, col3) where test.col1 = data.col1;
    :param connection: Коннект к базе данных
    :return: Количество выполненных строк
    """
    rowcount = 0
    connection.autocommit = False
    try:
        cur = connection.cursor()
        for sql_params in sql_params_list:
            sql, param_rows = sql_params
            if param_rows:
                pg_extras.execute_values(cur, sql, param_rows, page_size=200)
                rowcount += len(param_rows)

        connection.commit()
        cur.close()
    except Exception as e:
        connection.rollback()
        raise e
    return rowcount


def create_delete_sql(schema: str, table_name: str, primary_keys: List[str]) -> str:
    delete_part_query = ", ".join(primary_keys)
    sql = f"delete from {schema}.{table_name} where ({delete_part_query}) in (%s)"
    return sql


def create_insert_sql(schema: str, table_name: str, columns: List[str]) -> str:
    col_names = ", ".join(columns)
    sql = f"insert into {schema}.{table_name} ({col_names}) values %s"
    sql += " on conflict do nothing"
    return sql


def create_upsert_sql(schema: str, table_name: str, primary_keys: List[str], columns: List[str]) -> str:
    pkeys = ", ".join(primary_keys)
    col_names = ", ".join(columns)
    update_columns = [x for x in columns if x not in primary_keys]
    update_col_names = ", ".join(update_columns)
    col_names_excluded = "excluded." + ", excluded.".join(update_columns)

    sql = f"insert into {schema}.{table_name} ({col_names}) values %s"
    sql += f" on conflict({pkeys}) do update set({update_col_names}) = ({col_names_excluded})"
    return sql


def create_update_sql(table_name: str, columns: List[str], where_column: str) -> str:
    col_names = ", ".join(columns)
    update_columns = [x for x in columns if x not in [where_column]]
    update_col_names = ", ".join(update_columns)
    col_names_data = "data." + ", data.".join(update_columns)

    sql = f"""
    update {table_name} set({update_col_names}) = ({col_names_data})
    from (values %s) as data ({col_names})
    where {table_name}.{where_column} = data.{where_column}
    """

    return sql


def reg_type_enum(type, db_type_name):
    def adapt(type: enum.Enum):
        return extensions.AsIs(f"'{type.name}'::{db_type_name}")

    extensions.register_adapter(type, adapt)
