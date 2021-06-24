import unittest
from datetime import datetime, timedelta
from typing import Dict, List
import pandas as pd


def group_string_values(row: dict, keys: List[str]) -> str:
    return ','.join(map(lambda x: str(row[x]), keys))


def left_join_pure(left: list, right: list, left_on_keys: List[str], right_on_keys: List[str], right_select_keys: List[str]) -> list:
    right_dict: Dict[str, dict] = {}
    for row in right:
        key = group_string_values(row, right_on_keys)
        right_dict[key] = row

    for row in left:
        key = group_string_values(row, left_on_keys)
        for select_key in right_select_keys:
            row[select_key] = right_dict[key][select_key] if key in right_dict else None

    return left


def left_join_pd(left: list, right: list, left_on_keys: List[str], right_on_keys: List[str], right_select_keys: List[str]) -> list:
    df_left = pd.DataFrame(left)
    df_right = pd.DataFrame(right)
    df_merged = df_left.merge(df_right[right_on_keys + right_select_keys], left_on=left_on_keys, right_on=right_on_keys, how='left')

    return df_merged.to_dict('records')


class TestJoinUtils(unittest.TestCase):

    left_data = [
        {'well_id': 1, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 20), 'val1' : 11},
        {'well_id': 1, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 30), 'val1' : 12},
        {'well_id': 2, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 59), 'val1' : 13},
        {'well_id': 2, 'param_id': 1, 'dt' : datetime(1900, 2, 2, 23, 20), 'val1' : 14},
        {'well_id': 3, 'param_id': 1, 'dt' : datetime(1900, 2, 2, 23, 30), 'val1' : 15},
    ]
    right_data = [
        {'well_id': 1, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 20), 'val2' : 21},
        {'well_id': 1, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 30), 'val2' : 22},
        {'well_id': 2, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 59), 'val2' : 23},
        {'well_id': 2, 'param_id': 1, 'dt' : datetime(1900, 2, 2, 23, 20), 'val2' : 24},
        {'well_id': 3, 'param_id': 1, 'dt' : datetime(1900, 2, 2, 23, 30), 'val2' : 25},
    ]
    expected = [
        {'well_id': 1, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 20), 'val1' : 11, 'val2' : 21},
        {'well_id': 1, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 30), 'val1' : 12, 'val2' : 22},
        {'well_id': 2, 'param_id': 1, 'dt' : datetime(1900, 2, 1, 12, 59), 'val1' : 13, 'val2' : 23},
        {'well_id': 2, 'param_id': 1, 'dt' : datetime(1900, 2, 2, 23, 20), 'val1' : 14, 'val2' : 24},
        {'well_id': 3, 'param_id': 1, 'dt' : datetime(1900, 2, 2, 23, 30), 'val1' : 15, 'val2' : 25},
    ]

    def test_join_pure(self):
        on_keys = ['well_id', 'param_id', 'dt']
        result = left_join_pure(self.left_data, self.right_data, on_keys, on_keys, ['val2'])
        sorted_result = sorted(result, key=lambda k: k['dt'])

        self.assertListEqual(sorted_result, self.expected)

    def test_join_pd(self):
        on_keys = ['well_id', 'param_id', 'dt']
        result = left_join_pd(self.left_data, self.right_data, on_keys, on_keys, ['val2'])
        sorted_result = sorted(result, key=lambda k: k['dt'])

        self.assertListEqual(sorted_result, self.expected)

    @unittest.skip('long')
    def test_performance_join_pure(self):
        left_data, right_data = self.generate_data(500000)
        on_keys = ['well_id', 'param_id', 'dt']

        start = datetime.now()
        result = left_join_pure(left_data, right_data, on_keys, on_keys, ['val2'])
        print('Elapsed time pure: %s', datetime.now() - start)

        self.assertIsNotNone(result)

        self.assertIsNotNone(result)

    @unittest.skip('long')
    def test_performance_join_pd(self):
        left_data, right_data = self.generate_data(500000)
        on_keys = ['well_id', 'param_id', 'dt']

        start = datetime.now()
        result = left_join_pd(left_data, right_data, on_keys, on_keys, ['val2'])
        print('Elapsed time pd: %s', datetime.now() - start)

        self.assertIsNotNone(result)

    def generate_data(self, count: int) -> tuple:
        left_data = []
        right_data = []
        date = datetime(1900, 2, 1)
        for i in range(0, count):
            new_date = date + timedelta(hours=1)
            left_data.append({'well_id': i, 'param_id': i, 'dt' : new_date, 'val1' : i})
            right_data.append({'well_id': i, 'param_id': i, 'dt' : new_date, 'val2' : i})

        return left_data, right_data


if __name__ == '__main__':
    unittest.main()

# Elapsed time pure: 0:00:03.911000 | Memory: 353 Mb
# Elapsed time pd: 0:00:06.082999 | Memory: 586 Mb
