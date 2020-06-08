# Simple Python left outer join
t1 = [['aa'],['ff'],['er']]
t2 = [['aa', 11,],['er', 99,]]
d2 = dict(t2)
res = [[k[0], d2.get(k[0], 0)] for k in t1]
print(res)
# [['aa', 11], ['ff', 0], ['er', 99]]


# Python left outer join two sorted lists
left_sorted_list = [1, 2, 3, 4, 5]
right_sorted_list = [[2, 21], [4, 45]]
right_dict = dict(right_sorted_list)
# Способ 1
left_outer_join1 = [[l, right_dict.get(l)] for l in left_sorted_list]
# Способ 2
left_outer_join2 =[(x, right_dict[x] if x in right_dict else None) for x in left_sorted_list]
print(left_outer_join1)
print(left_outer_join2)
# [[1, None], [2, 21], [3, None], [4, 45], [5, None]]


# Left Join two lists of tuples
a = [(1,'f','e'),(7,'r',None),(2,'s','f'),(32,None,'q')]
b = [(32,'dd'), (1,'pp')]
b_dict = {item[0]: item for item in b}
res2 = [item + b_dict.get(item[0], (None, None)) for item in a]
print(res2)
# [(1, 'f', 'e', 1, 'pp'), (7, 'r', None, None, None), (2, 's', 'f', None, None), (32, None, 'q', 32, 'dd')]


# Left Join - pandas http://pandas.pydata.org/pandas-docs/stable/merging.html
# pip install pandas
import pandas as pd
a = [{'a1':1,'a2':'f', 'a3':'e'}, {'a1':2, 'a2':'r', 'a3':None}]
b = [{'b1':32, 'b2':'dd'}, {'b1':1, 'b2':'pp'}]
pd_a = pd.DataFrame(a)
pd_b = pd.DataFrame(b)
result = pd.merge(pd_a, pd_b, left_on='a1', right_on='b1', how='left')
print(result)
"""
   a1 a2    a3  b1   b2
0   1  f     e   1   pp
1   2  r  None NaN  NaN
"""

# SQL JOIN in NumPy
import numpy as NP
A = NP.random.randint(10, 100, 40).reshape(8, 5)
a = NP.random.randint(1, 3, 8).reshape(8, -1)    # add column of primary keys      
A = NP.column_stack((a, A))

B = NP.random.randint(0, 10, 4).reshape(2, 2)
b = NP.array([1, 2])
B = NP.column_stack((b, B))
# prepare the array that will hold the 'result set':
AB = NP.column_stack((A, NP.zeros((A.shape[0], B.shape[1]-1))))
def join(A, B) :
    '''
    returns None, side effect is population of 'results set' NumPy array, 'AB';
    pass in A, B, two NumPy 2D arrays, representing the two SQL Tables to join
    '''
    k, v = B[:,0], B[:,1:]
    dx = dict(zip(k, v))
    for i in range(A.shape[0]) :
        AB[i:,-2:] = dx[A[i,0]]
def group_by(AB, col_id) :
    '''
    returns 2D NumPy array aggregated on the unique values in column specified by col_id;
    pass in a 2D NumPy array and the col_id (integer) which holds the unique values to group by
    '''
    uv = NP.unique(AB[:,col_id]) 
    temp = []
    for v in uv :
        ndx = AB[:,0] == v          
        temp.append(NP.sum(AB[:,1:][ndx,], axis=0))
    temp = NP. row_stack(temp)
    uv = uv.reshape(-1, 1)
    return NP.column_stack((uv, temp))
print(A)
print(B)
join(A, B)
print(AB)
AB = group_by(AB, 0)
print(AB)
"""
>>> A
  array([[ 1, 92, 50, 67, 51, 75],
         [ 2, 64, 35, 38, 69, 11],
         [ 1, 83, 62, 73, 24, 55],
         [ 2, 54, 71, 38, 15, 73],
         [ 2, 39, 28, 49, 47, 28],
         [ 1, 68, 52, 28, 46, 69],
         [ 2, 82, 98, 24, 97, 98],
         [ 1, 98, 37, 32, 53, 29]])

>>> B
  array([[1, 5, 4],
         [2, 3, 7]])

>>> join(A, B)
  array([[  1.,  92.,  50.,  67.,  51.,  75.,   5.,   4.],
         [  2.,  64.,  35.,  38.,  69.,  11.,   3.,   7.],
         [  1.,  83.,  62.,  73.,  24.,  55.,   5.,   4.],
         [  2.,  54.,  71.,  38.,  15.,  73.,   3.,   7.],
         [  2.,  39.,  28.,  49.,  47.,  28.,   3.,   7.],
         [  1.,  68.,  52.,  28.,  46.,  69.,   5.,   4.],
         [  2.,  82.,  98.,  24.,  97.,  98.,   3.,   7.],
         [  1.,  98.,  37.,  32.,  53.,  29.,   5.,   4.]])

>>> group_by(AB, 0)
  array([[   1.,  341.,  201.,  200.,  174.,  228.,   20.,   16.],
         [   2.,  239.,  232.,  149.,  228.,  210.,   12.,   28.]])
"""

