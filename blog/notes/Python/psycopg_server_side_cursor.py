# stdlib
from typing import Generator, Optional

# thirdparty
from psycopg2 import extensions


def tuples_to_dict(cursor, rows):
    columns = [i[0].lower() for i in cursor.description]
    return [dict(zip(columns, row)) for row in rows]


def fetch_data_from_db(
    query: str, params: dict, connection: extensions.connection, cursor_name: Optional[str], batch_size: int = 10000
) -> Generator:
    """
    Получает данные с БД, возвращая данные итеративно, являясь генератором

    :param query: SQL-запрос
    :param params: Параметры запроса
    :param connection: Соединение с БД
    :param cursor_name: Наименование курсора. Если задан None, то курсор создаётся на стороне клиента
        (могут быть затраты RAM у клиента). Желательно создавать уникальное наименование
    :param batch_size: Размер пачки для фетча данных
    :return: Полученные с БД данные
    """
    try:
        # Создание курсора
        with connection.cursor(cursor_name) as cur:
            cur.execute(query, params)
            while True:
                records = cur.fetchmany(batch_size)
                if not records:
                    return []
                rows = tuples_to_dict(cur, records)
                yield rows
    except Exception as ex:
        connection.rollback()
        raise ex

