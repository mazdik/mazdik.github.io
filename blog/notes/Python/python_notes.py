# Merge dictionaries
z = {**x, **y}

# Merge lists
mergedlist = listone + listtwo

# Merge tuples (запятая в конце если 1 значение)
t = ('age',) + ('name',)

# Type checking
type(begin_date) is datetime
type(o) is str
isinstance(begin_date, datetime)

# Cheking List
len(rows)
if not a:
  print("List is empty")

# nvl - ternary operator
result = a if a is not None else b
result = a or "some default value"
42    or "something"    # returns 42
0     or "something"    # returns "something"
None  or "something"    # returns "something"
False or "something"    # returns "something"
""    or "something"    # returns "something"

# unique values from a list
mylist = list(set(mylist))

# maintain sequence of my list using set (сохранить последовательность)
sorted(set(mylist), key=mylist.index)

# remove duplicates
intervals = [dict(t) for t in {tuple(d.items()) for d in intervals}]

# How to convert list of tuples to tuple
# [('1243',), ('NAME',)] => ['1243', 'NAME']
rows = [row[0] for row in rows]

# cursor to empty dict list
columns = [i[0] for i in cur.description]
empty_row = [dict(zip(columns, [None] * len(columns)))]

# Converting a list to dictionary
# {2:0 , 3:0 , 5:0 , 7:0 , 11:0}
my_list = [2, 3, 5, 7, 11]
my_dict = {k: 0 for k in my_list}

# variable name as a string
def name(**variables):
	return [x for x in variables][0]
name(variable=variable)

# Date
date = datetime.strptime('15.08.2017 8:30:21', '%d.%m.%Y %H:%M:%S')
datetime.today()
datetime.today() - timedelta(days=1)
timedelta(float(1 / 24))
(datetime.today() + timedelta(1)) - datetime.today()
# Add 1 month
from dateutil import relativedelta
end_date = begin_date + relativedelta.relativedelta(months=1)
# Truncate Python DateTime
begin_date = date.replace(hour=0, minute=0, second=0, microsecond=0)
dt = datetime.date(dt.year, dt.month, dt.day)
month_begin = today.replace(day=1)
prev_month_begin = (month_begin - timedelta(days=1)).replace(day=1)
# Доля времени
td.total_seconds()/timedelta(days=1).total_seconds() 
td.total_seconds()/24*60*60
td/timedelta(days=1)

# Парсер даты
import dateutil.parser
d2=dateutil.parser.parse(d1)

# dict to class
class allMyFields(object):
    Field1 = None
    Field2 = None
    def __init__(self, dictionary):
        self.__dict__.update(dictionary)

q = { 'Field1' : 3000, 'Field2' : 6000, 'RandomField' : 5000 }
instance = allMyFields(q)

# print list of class
print([x.__dict__ for x in dates])

# reversed copy
mylist[::-1]

# цикл между 2 датами по 1 дню
for i in range((end_date - begin_date).days + 1):
    print((begin_date + timedelta(days=i)).strftime('%Y.%m.%d'))

# цикл между 2 датами по 2 часа
for i in range((end_date - begin_date).days*24 + 1):
    if (i % 2) == 0:
        print((begin_date + timedelta(hours=i)).strftime('%Y-%m-%dT%H:%M'))
