# LINQ
from s in names
where s.Length == 5
orderby s
select s.ToUpper()
# Python
sorted(s.upper() for s in names if len(s) == 5)

# For where
for x in (y for y in items if y > 10):
for table in (t for t in tables if t == 'reestr_obj'):
# List filtering
my_list = [x for x in my_list if x.attribute == value]
my_list = filter(lambda x: x.attribute == value, my_list)

# Date
date = datetime.strptime('15.08.2017 8:30:21', '%d.%m.%Y %H:%M:%S')
# Add month
import datetime
from dateutil import relativedelta
nextmonth = datetime.date.today() + relativedelta.relativedelta(months=1)

# Merge dictionaries
z = {**x, **y}
-- Merge lists
mergedlist = listone + listtwo
-- Concatenate tuple (запятая в конце если 1 значение)
t = ('age',) + ('name',)

# Type checking
type(begin_date) is datetime
type(o) is str
isinstance(begin_date, datetime)

# Cheking List
len(rows)
if not a:
  print("List is empty")
  
# unique values from a list
mylist = list(set(mylist))
# maintain sequence of my list using set (сохранить последовательность)
sorted(set(mylist), key=mylist.index)

# How to convert list of tuples to tuple
# [('1243',), ('XR0011',)] => ['1243', 'XR0011']
rows = [row[0] for row in rows]

# cursor to empty dict list
columns = [i[0] for i in cur.description]
empty_row = [dict(zip(columns, [None] * len(columns)))]

# Converting a list to dictionary
# {2:0 , 3:0 , 5:0 , 7:0 , 11:0}
my_list = [2, 3, 5, 7, 11]
my_dict = {k: 0 for k in my_list}

# Map with condition
map(lambda x: 'lower' if x < 3 else 'higher', lst)
['lower' if x < 3 else 'higher' for x in lst]

# variable name as a string
def name(**variables):
	return [x for x in variables][0]
name(variable=variable)
	
# Renaming columns in pandas
df.columns = df.columns.map(lambda x: 'well_id' if str(x) == 'well_id' else str(x) + '_' + key)
df.rename(columns={'oldName1': 'newName1', 'oldName2': 'newName2'}, inplace=True)
df.rename(columns=lambda x: x.replace('$', ''), inplace=True)
# Задание типов и копирование
df1 = df_dimension[['well_id', 'begin_date', 'end_date']].astype(
	dtype={"well_id": "int64", "begin_date": "object", "end_date": "object"})

# Replacing None with NaN in pandas
df.fillna(value=np.NaN, inplace=True)
df['dt'].fillna(value=pd.NaT, inplace=True)
# Pandas replace NaN with NaT
df['dt'] = pd.to_datetime(df['dt'])
df['dt'] = df['dt'].astype(np.datetime64).fillna(pd.NaT)
# fillna конвертирует NaT в 1970-01-01
df['four'].fillna(value=0, inplace=True)

# Название колонок или индексов (при axis=1 это названия колонок)
df.columns
df.index
# dataframe column headers all lowercase
df.columns = map(str.lower, df.columns)

# Цикл df
for index, row in df.iterrows():

# pandas: apply a function with arguments
my_series.apply(lambda x: your_func(a,b,c,d,...,x))

# pandas convert index to column dataframe
df.reset_index(inplace=True)

# pandas pivot_table
df = pd.io.sql.read_sql_query(sql, conn, params={'ddate': ddate})
df = df.pivot_table(index=['ddate', 'well_id', 'layer_id', 'purpose_id', 'expl_method_id', 'agent_id'],
                    columns=['code'],
                    values='nvalue', aggfunc=np.sum, fill_value=0)
# df = df.set_index(['ddate', 'well_id', 'layer_id', 'purpose_id', 'expl_method_id', 'agent_id', 'code']).unstack('code')
df.reset_index(inplace=True)

# Date
datetime.today()
datetime.today() - timedelta(days=1)
timedelta(float(1 / 24))
(datetime.today() + timedelta(1)) - datetime.today()
# + 1 month
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

# nvl - ternary operator
a if condition else b
a if a is not None else b
other = s or "some default value"
42    or "something"    # returns 42
0     or "something"    # returns "something"
None  or "something"    # returns "something"
False or "something"    # returns "something"
""    or "something"    # returns "something"

# Merge with condition
df_left = DataFrame([[1,3,4],[2,3,5],[NaN,2,8]], index=['a','b','c'], columns=['one', 'two', 'three'])
df_right = DataFrame([[4,2],[3,6]], index=['b','c'], columns=['one','two'])

df_merged = merge(df_left, df_right, left_index = True, right_index = True, how='left')
# Coalescing two columns (like SQLs NVL/COALESCE functions)
df_merged['one'] = df_merged.one_x.fillna(df_merged.one_y)
# Setting a columns value depending on another (three might be the rowcount)
df_merged['two'] = df_merged.apply(lambda row: row.two_y if row.three <= 3 else row.two_x, axis=1)
# possibly many more of these
df_final = df_merged.drop(['one_x','one_y','two_x','two_y'], axis=1)

# Where with NaN
mask = (df.date >= df.begin_date) & ((df.date < df.end_date) | (df.end_date.isnull()))
df = df.where(mask)
# Where without NaN
df = df[(df.date >= df.begin_date) & ((df.date < df.end_date) | (df.end_date.isnull()))]

# List unique values
df.name.unique()
# Disticnt
df1 = df.drop_duplicates(subset=['well_id', 'begin_date', 'layer_id'])
df1[['well_id', 'begin_date', 'layer_id']]

# pandas remove duplicate columns
df = df.loc[:, ~df.columns.duplicated()]

# AN
if any(x == big_foobar for x in foobars):

# DataFrame.to_dict list
df.to_dict('records')
[{'col1': 1, 'col2': 0.5}, {'col1': 2, 'col2': 0.75}]

# pandas интерполяция
df['liq'].replace(0, np.NaN, inplace=True)
df['liq'].interpolate(method='pad', limit=500, limit_direction='forward', inplace=True)

# sort a list of dictionaries
sortedlist = sorted(list_to_be_sorted, key=lambda k: k['name'] , reverse=True)

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

# Количество строк в pandas
len(df.index)

# reversed copy
mylist[::-1]

# Количество не пустых столбцов в df
not_empty_cols = df.any()
cnt_not_empty_cols = not_empty_cols.sum()
print(not_empty_cols)
print('cnt_not_empty_cols: ' + str(cnt_not_empty_cols))
s1    False
s2    True
s3    True
cnt_not_empty_cols: 2

# цикл между 2 датами по 1 дню
for i in range((end_date - begin_date).days + 1):
    print((begin_date + timedelta(days=i)).strftime('%Y.%m.%d'))

# цикл между 2 датами по 2 часа
for i in range((end_date - begin_date).days*24 + 1):
    if (i % 2) == 0:
        print((begin_date + timedelta(hours=i)).strftime('%Y-%m-%dT%H:%M'))
