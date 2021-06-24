from typing import List


def key_string_values(row: dict, keys: List[str]) -> str:
    return ','.join(map(lambda x: str(row[x]), keys))


def pivot_keys(rows: list, group_keys: List[str], column_key: str, value_key: str, column_prefix: str) -> list:
    res = {}
    for row in rows:
        key = key_string_values(row, group_keys)
        if key not in res:
            res[key] = {}
            for group_key in group_keys:
                res[key][group_key] = row[group_key]

        field = column_prefix + str(row[column_key]) if column_prefix else row[column_key]
        res[key][field] = row[value_key]

    return list(res.values())


def add_empty_keys(rows: list, fill_value=None) -> list:
    unique_keys = list(set(k for row in rows for k in row.keys()))
    for row in rows:
        for key in unique_keys:
            if key not in row:
                row[key] = fill_value
    return rows


def pivot(rows: list, group_keys: List[str], column_key: str, value_key: str, column_prefix: str, fill_value=None) -> list:
    data = pivot_keys(rows, group_keys, column_key, value_key, column_prefix)
    data = add_empty_keys(data, fill_value)
    return data




import unittest
from datetime import datetime


class TestRowsToCols(unittest.TestCase):

    rows = [
        {'well_id': 1001, 'dt': datetime(1900, 1, 1), 'param_id': 1, 'val': 10},
        {'well_id': 1001, 'dt': datetime(1900, 1, 1), 'param_id': 2, 'val': 20},
        {'well_id': 1001, 'dt': datetime(1900, 1, 1), 'param_id': 3, 'val': 30},
        {'well_id': 1001, 'dt': datetime(1900, 1, 2), 'param_id': 4, 'val': 40},
        {'well_id': 1001, 'dt': datetime(1900, 1, 2), 'param_id': 5, 'val': 50},
        {'well_id': 1002, 'dt': datetime(1900, 1, 1), 'param_id': 1, 'val': 11},
        {'well_id': 1002, 'dt': datetime(1900, 1, 1), 'param_id': 2, 'val': 21},
        {'well_id': 1002, 'dt': datetime(1900, 1, 1), 'param_id': 3, 'val': 31},
        {'well_id': 1002, 'dt': datetime(1900, 1, 2), 'param_id': 4, 'val': 41},
        {'well_id': 1002, 'dt': datetime(1900, 1, 2), 'param_id': 5, 'val': 51}
    ]

    def test_pivot_keys(self):
        expected = [
            {'well_id': 1001, 'p1': 10, 'p2': 20, 'p3': 30, 'p4': 40, 'p5': 50},
            {'well_id': 1002, 'p1': 11, 'p2': 21, 'p3': 31, 'p4': 41, 'p5': 51}
        ]
        result = rows_to_cols.pivot_keys(self.rows, ['well_id'], 'param_id', 'val', 'p')
        self.assertEqual(result, expected)

    def test_pivot_keys_no_prefix(self):
        expected = [
            {'well_id': 1001, 1: 10, 2: 20, 3: 30, 4: 40, 5: 50},
            {'well_id': 1002, 1: 11, 2: 21, 3: 31, 4: 41, 5: 51}
        ]
        result = rows_to_cols.pivot_keys(self.rows, ['well_id'], 'param_id', 'val', None)
        self.assertEqual(result, expected)

    def test_pivot_keys_multiple(self):
        expected = [
            {'well_id': 1001, 'dt': datetime(1900, 1, 1), 'p1': 10, 'p2': 20, 'p3': 30},
            {'well_id': 1001, 'dt': datetime(1900, 1, 2), 'p4': 40, 'p5': 50},
            {'well_id': 1002, 'dt': datetime(1900, 1, 1), 'p1': 11, 'p2': 21, 'p3': 31},
            {'well_id': 1002, 'dt': datetime(1900, 1, 2), 'p4': 41, 'p5': 51}
        ]
        result = rows_to_cols.pivot_keys(self.rows, ['well_id', 'dt'], 'param_id', 'val', 'p')
        self.assertEqual(result, expected)

    def test_add_empty_keys(self):
        expected = [
            {'well_id': 1001, 'dt': datetime(1900, 1, 1), 'p1': 10, 'p2': 20, 'p3': 30, 'p4': None, 'p5': None},
            {'well_id': 1001, 'dt': datetime(1900, 1, 2), 'p4': 40, 'p5': 50, 'p1': None, 'p2': None, 'p3': None},
            {'well_id': 1002, 'dt': datetime(1900, 1, 1), 'p1': 11, 'p2': 21, 'p3': 31, 'p4': None, 'p5': None},
            {'well_id': 1002, 'dt': datetime(1900, 1, 2), 'p4': 41, 'p5': 51, 'p1': None, 'p2': None, 'p3': None}
        ]
        result = rows_to_cols.pivot_keys(self.rows, ['well_id', 'dt'], 'param_id', 'val', 'p')
        result = rows_to_cols.add_empty_keys(result, None)
        self.assertEqual(result, expected)

    def test_pivot(self):
        expected = [
            {'well_id': 1001, 'dt': datetime(1900, 1, 1), 'p1': 10, 'p2': 20, 'p3': 30, 'p4': None, 'p5': None},
            {'well_id': 1001, 'dt': datetime(1900, 1, 2), 'p4': 40, 'p5': 50, 'p1': None, 'p2': None, 'p3': None},
            {'well_id': 1002, 'dt': datetime(1900, 1, 1), 'p1': 11, 'p2': 21, 'p3': 31, 'p4': None, 'p5': None},
            {'well_id': 1002, 'dt': datetime(1900, 1, 2), 'p4': 41, 'p5': 51, 'p1': None, 'p2': None, 'p3': None}
        ]
        result = rows_to_cols.pivot(self.rows, ['well_id', 'dt'], 'param_id', 'val', 'p')
        self.assertEqual(result, expected)


if __name__ == '__main__':
    unittest.main()
