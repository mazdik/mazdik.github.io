from datetime import datetime
from dateutil import relativedelta
import pandas as pd


t1=[
{'BEGIN_DATE': '07.07.2017 8:30:21', 'END_DATE': '16.08.2017 8:30:21', 'RN': 1},
{'BEGIN_DATE': '16.08.2017 8:30:21', 'END_DATE': '17.08.2017 8:30:21', 'RN': 2},
{'BEGIN_DATE': '17.08.2017 8:30:21', 'END_DATE': None, 'RN': 3}
]

t2=[
{'BEGIN_DATE': '17.07.2017 8:30:21', 'END_DATE': '15.08.2017 8:30:21', 'RN': 1, 'NID':123},
{'BEGIN_DATE': '15.08.2017 8:30:21', 'END_DATE': '16.08.2017 8:30:21', 'RN': 2},
{'BEGIN_DATE': '16.08.2017 8:30:21', 'END_DATE': None, 'RN': 3}
]

"""
Нужен такой результат
1	01.08.2017 00:00:00	07.07.2017 8:30:21	16.08.2017 8:30:21	1	17.07.2017 8:30:21	15.08.2017 8:30:21	1
2	15.08.2017 8:30:21	07.07.2017 8:30:21	16.08.2017 8:30:21	1	15.08.2017 8:30:21	16.08.2017 8:30:21	2
3	16.08.2017 8:30:21	16.08.2017 8:30:21	17.08.2017 8:30:21	2	16.08.2017 8:30:21	None				3
4	17.08.2017 8:30:21	17.08.2017 8:30:21	None				3	16.08.2017 8:30:21	None				3
"""

def to_dt(str_date):
	if str_date is not None and type(str_date) is not datetime:
		return datetime.strptime(str_date, '%d.%m.%Y %H:%M:%S')

# Конвертация формата строки в даты
for row in t1:
	row['BEGIN_DATE'] = to_dt(row['BEGIN_DATE'])
	row['END_DATE'] = to_dt(row['END_DATE'])
for row in t2:
	row['BEGIN_DATE'] = to_dt(row['BEGIN_DATE'])
	row['END_DATE'] = to_dt(row['END_DATE'])

# Список уникальных дат и сортировка
begin_date = to_dt('01.08.2017 00:00:00')
end_date = begin_date + relativedelta.relativedelta(months=1)
uniqueList = [begin_date]
for el in t1:
	if el['BEGIN_DATE'] not in uniqueList:
		uniqueList.append(el['BEGIN_DATE'])
for el in t2:
	if el['BEGIN_DATE'] not in uniqueList:
		uniqueList.append(el['BEGIN_DATE'])
uniqueList.sort()
# Отбрасываем лишние даты
uniqueList = [date for date in uniqueList if date >= begin_date and date < end_date]

unique_dates = []
for date in uniqueList :
	unique_dates.append({'DATE': date})

pd_ud = pd.DataFrame(unique_dates)
pd_t1 = pd.DataFrame(t1)
pd_t2 = pd.DataFrame(t2)

pd_ud['key'] = 0
pd_t1['key'] = 0
pd_t2['key'] = 0

df = pd_ud.merge(pd_t1, on='key', how='left')
df = df.merge(pd_t2, on='key', how='left')
# df.drop('key',1, inplace=True)

# df = df[(df.DATE >= df.BEGIN_DATE_x) & ((df.DATE < df.END_DATE_x) | (df.END_DATE_x.isnull())) & (df.DATE >= df.BEGIN_DATE_y) & ((df.DATE < df.END_DATE_y) | (df.END_DATE_y.isnull()))]

df = df[(df.DATE >= df.BEGIN_DATE_x) & ((df.DATE < df.END_DATE_x) | (df.END_DATE_x.isnull()))]
df = df[(df.DATE >= df.BEGIN_DATE_y) & ((df.DATE < df.END_DATE_y) | (df.END_DATE_y.isnull()))]

# add column
df.insert(1,'END_DATE', None) 
# LEAD(DATE,1,NULL) OVER (PARTITION BY key ORDER BY DATE ASC) AS END_DATE
df['END_DATE'] = df.groupby(['key'])['DATE'].shift(-1)
# update df set END_DATE = end_date where END_DATE is null
df.loc[df['END_DATE'].isnull(), 'END_DATE'] = end_date

print(df)


