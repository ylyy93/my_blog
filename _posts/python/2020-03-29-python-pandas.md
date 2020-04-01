---
layout: post
title: Python - Pandas
date: 2020-03-29 19:04 -0700
categories: Coding
tags: [Python]
---

# [Tutorialspoint](https://www.tutorialspoint.com/python_pandas/python_pandas_dataframe.htm)
## 1. DataFrame Creation
```python
pandas.DataFrame(data, index, columns, dtype, copy)
# data: lists, dict, Series, Numpy ndarrays, Another DataFrame
```

### 1.1 Empty DataFrame
```python
import pandas as pd
df0 = pd.DataFrame()
print(df0)
```

```bash
Empty DataFrame
Columns: []
Index: []
```

### 1.2 Create a DataFrame from Lists
```python
df1 = pd.DataFrame([1,2,3,4,5])
print(df1)
```

```bash
0
0    1
1    2
2    3
3    4
4    5
```

```python
df2 = pd.DataFrame([['Alex',10],['Bob',12],['Clarke',13]],
                   columns = ['Name', 'Age'],
                   dtype = float) # by row
print(df2)
```

```bash
Name  Age
0    Alex   10.0
1     Bob   12.0
2  Clarke   13.0
```

### 1.3 Create a DataFrame from Dict of ndarrays/ Lists
```python
df3 = pd.DataFrame({'Name': ['Tom', 'Jack', 'Steve', 'Ricky'],
                    'Age':  [28,34,29,42]},
                    index = ['rank1','rank2','rank3','rank4'])
print(df3)
```

```bash
        Name  Age
rank1    Tom   28
rank2   Jack   34
rank3  Steve   29
rank4  Ricky   42
```

### 1.4 Create a DataFrame from List of Dicts
```python
df4 = pd.DataFrame([{'a':1, 'b':2},
                    {'a':5, 'b':10, 'c': 20}],
                   index = ['first','second'])
print(df4)                    
```

```bash
        a   b     c
first   1   2   NaN
second  5  10  20.0
```

* columns names need to match
```python
import pandas as pd
data = [{'a': 1, 'b': 2},{'a': 5, 'b': 10, 'c': 20}]

#With two column indices, values same as dictionary keys
df4_1 = pd.DataFrame(data, index=['first', 'second'], columns=['a', 'b'])

#With two column indices with one index with other name
df4_2 = pd.DataFrame(data, index=['first', 'second'], columns=['a', 'b1'])
print df4_1
print df4_2
```

```bash
#df4_1 output
         a  b
first    1  2
second   5  10

#df4_2 output
         a  b1
first    1  NaN
second   5  NaN
```

### 1.5 Create a DataFrame from Dict of Series
```python
df5 = pd.DataFrame({'one': pd.Series([1,2,3], index = ['a','b','c']),
                    'two': pd.Series([1,2,3,4], index = list('abcd'))})
print(df5)                     
```

```bash
one  two
a  1.0    1
b  2.0    2
c  3.0    3
d  NaN    4
```

### 2.1 Columns Selection `df['col']`
```python
print(df5['one'])
```

```bash
a    1.0
b    2.0
c    3.0
d    NaN
Name: one, dtype: float64
```

### 2.2 Column Addition

```python
df5['three']=pd.Series([10,20,30],index=['a','b','c'])
df5['four']=df5['one']+df5['three']
print(df5)
```

```bash
   one  two  three  four
a  1.0    1   10.0  11.0
b  2.0    2   20.0  22.0
c  3.0    3   30.0  33.0
d  NaN    4    NaN   NaN
```

### 2.3 Column Deletion

```python
del df5['four']
print(df5)
```

```bash
   one  two  three
a  1.0    1   10.0
b  2.0    2   20.0
c  3.0    3   30.0
d  NaN    4    NaN
```

### 3.1 Row Selection, Addition, and Deletion

###### Selection
```python
df5.loc['b']
df5.iloc[1]
df5[2:4]
```

###### Addition  (rbind)
```python
df6_1 = pd.DataFrame([[1, 2], [3, 4]], columns = ['a','b'])
df6_2 = pd.DataFrame([[5, 6], [7, 8]], columns = ['a','b'])
df6_1 = df6_1.append(df6_2)
print(df6_1)
```

```bash
   a  b
0  1  2
1  3  4
0  5  6
1  7  8
```

###### Deletion of Rows
```python
df6_1 = df6_1.drop(0)
print(df6_1)
```

```bash
   a  b
1  3  4
1  7  8
```

# [10 minutes to pandas](https://pandas.pydata.org/pandas-docs/stable/getting_started/10min.html)
```python
df2 = pd.DataFrame({'A': 1.,
                    'B': pd.Timestamp('20130102'),
                    'C': pd.Series(1, index=list(range(4)), dtype='float32'),
                    'D': np.array([3] * 4, dtype='int32'),
                    'E': pd.Categorical(["test", "train", "test", "train"]),
                    'F': 'foo'})

df2                    
```

```bash
     A          B    C  D      E    F
0  1.0 2013-01-02  1.0  3   test  foo
1  1.0 2013-01-02  1.0  3  train  foo
2  1.0 2013-01-02  1.0  3   test  foo
3  1.0 2013-01-02  1.0  3  train  foo
```

```python
df2.dtypes

# A           float64
# B    datetime64[ns]
# C           float32
# D             int32
# E          category
# F            object
# dtype: object
```

```python
df.head()
df.tail(3)
df.index # row names
df.columns # col names
df.to_numpy()
df.describe() # summary
df.T # transpose
df.sort_index(axis=1, ascending=False) # sort by column name
df.sort_values(by='B') # sort by values
# select columns
df.A
df['A']
df.loc[:, ['A', 'B']]
# select rows
df[0:3]
df['20130102':'20130104']
```


## Select by label
```python
df.loc[dates[0]]
# both columns and rows
df.loc['20130102':'20130104', ['A', 'B']]
# scalar value
df.loc[dates[0], 'A']
# faster scalar value
df.at[dates[0], 'A']
```

## Select by position
```python
# rows
df.iloc[3]
df.iloc[1:3, :]
# columns
df.iloc[:, 1:3]
# rows and columns
df.iloc[3:5, 0:2]
df.iloc[[1, 2, 4], [0, 2]]
# scalar value
df.iloc[1, 1]
# faster scalar
df.iat[1, 1]
```

## Boolean indexing

```python
df[df['A'] > 0]
df[df > 0]
df2 = df.copy()
df2['E'] = ['one', 'one', 'two', 'three', 'four', 'three']
df2
df2[df2['E'].isin(['two', 'four'])]
```

## Missing value
```python
df1 = df.reindex(index=dates[0:4], columns=list(df.columns) + ['E'])
df1.loc[dates[0]:dates[1], 'E'] = 1
df1
```

```python
df1.dropna(how='any')
df1.fillna(value=5)
pd.isna(df1)
```

## Operations

```python
df.mean() # by columns
df.mean(1) # by row
```

... To be continued


- [](https://pandas.pydata.org/pandas-docs/stable/getting_started/10min.html)
