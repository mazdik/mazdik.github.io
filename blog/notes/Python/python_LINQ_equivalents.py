# LINQ
from s in names
where s.Length == 5
orderby s
select s.ToUpper()
# Python
sorted(s.upper() for s in names if len(s) == 5)

# filter is equivalent to Where
my_list = filter(lambda x: x['attribute'] == value, my_list)
my_list = [x for x in my_list if x['attribute'] == value]

# map is equivalent to Select
# map with condition
map(lambda x: 'lower' if x < 3 else 'higher', my_list)
['lower' if x < 3 else 'higher' for x in my_list]

# all is equivalent to All
result = all(x < 3 for x in my_list)

# any is equivalent to Any
result = any(x < 3 for x in my_list)

# sort is equivalent to OrderBy
sorted_list = sorted(my_list, key=lambda k: k['name'] , reverse=True)
# sort by date
min_date = datetime(1900, 1, 1)
intervals = sorted(intervals, key=lambda k: k['date'] if k['date'] is not None else min_date)

# reduce is "kinda" equivalent to Aggregate
from functools import reduce
reduce(lambda x, y: x + y, [1, 2, 3], 6) # 12

# reduce list of dict
rows = [
    {'name': 'test1', 'a': 1, 'b': 10},
    {'name': 'test2', 'a': 2, 'b': 20},
    {'name': 'test3', 'a': 3, 'b': 30}
]
reduce(lambda x, y: x + y['a'], rows, 0) # 6
reduce(lambda x, y: {'a': x['a'] + y['a'], 'b': x['b'] + y['b']}, rows) # {'a': 6, 'b': 60}
