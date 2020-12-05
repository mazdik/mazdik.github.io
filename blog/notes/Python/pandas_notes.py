# Количество строк в pandas
len(df.index)

# DataFrame.to_dict list
df.to_dict('records')
[{'col1': 1, 'col2': 0.5}, {'col1': 2, 'col2': 0.75}]

# pandas интерполяция
df['liq'].replace(0, np.NaN, inplace=True)
df['liq'].interpolate(method='pad', limit=500, limit_direction='forward', inplace=True)

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

# Количество не пустых столбцов в df
not_empty_cols = df.any()
cnt_not_empty_cols = not_empty_cols.sum()
print(not_empty_cols)
print('cnt_not_empty_cols: ' + str(cnt_not_empty_cols))
s1    False
s2    True
s3    True
cnt_not_empty_cols: 2
