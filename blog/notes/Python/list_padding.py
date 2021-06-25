from typing import List, Callable


def padding_forward(rows: List[dict], keys: List[str], sort_key: Callable) -> List[dict]:
    if len(rows) <= 1:
        return rows

    sorted_rows = sorted(rows, key=sort_key)

    for index, row in enumerate(sorted_rows):
        for key in keys:
            if key in row and row[key] is None and sorted_rows[index-1][key] is not None:
                row[key] = sorted_rows[index-1][key]

    return rows
