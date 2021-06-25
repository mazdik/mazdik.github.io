from typing import List, Dict


def key_string_values(row: dict, keys: List[str]) -> str:
    return ','.join(map(lambda x: str(row[x]), keys))


def group_and_sum(rows: list, group_keys: List[str], sum_keys: List[str]) -> list:
    res = {}
    for row in rows:
        key = key_string_values(row, group_keys)
        if key in res and res[key] is not None:
            for sum_key in sum_keys:
                res[key][sum_key] += row[sum_key] if row[sum_key] is not None else 0
        else:
            res[key] = {}
            for group_key in group_keys:
                res[key][group_key] = row[group_key]
            for sum_key in sum_keys:
                res[key][sum_key] = row[sum_key] if row[sum_key] is not None else 0

    return list(res.values())


def group_by(rows: List[dict], group_keys: List[str]) -> Dict[str, list]:
    res = {}
    for row in rows:
        key = key_string_values(row, group_keys)
        if key in res and res[key] is not None:
            res[key].append(row)
        else:
            res[key] = [row]
    return res


def get_min_max(rows: list, field: str) -> Tuple[Optional[float], Optional[float]]:
    if len(rows) == 0:
        return None, None
    field_values = [x[field] for x in rows]
    if all(x is None for x in field_values):
        return None, None
    return min(field_values), max(field_values)


def get_last_group_rows(rows: List[dict], group_keys: List[str], sort_key: Callable, count: int) -> list:
    """ Последние n строк для каждой группы """
    res = []
    count = int(count)
    grouped = group_by(rows, group_keys)
    for key in grouped:
        param_rows = grouped[key]
        if len(param_rows) > count:
            sorted_rows = sorted(param_rows, key=sort_key)
            res = res + sorted_rows[-count:]
        else:
            res = res + param_rows
    return res
